#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "::error::$*" >&2
  exit 1
}

version_pattern='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
[[ "${VERSION:-}" =~ $version_pattern ]] || fail 'Version must use x.y.z, for example 1.0.15.'
[[ "${BUILD_NUMBER:-}" =~ ^[1-9][0-9]*$ ]] || fail 'Build number must be a positive integer.'
for value in "$ANDROID" "$IOS" "$DRAFT"; do
  [[ "$value" == true || "$value" == false ]] || fail 'Platform and draft inputs must be booleans.'
done
[[ "$ANDROID" == true || "$IOS" == true ]] || fail 'Select at least one platform.'
if [[ "$ANDROID" == true ]]; then
  if [[ ${#BUILD_NUMBER} -gt 10 ]] || (( 10#$BUILD_NUMBER > 2100000000 )); then
    fail 'Android build numbers cannot exceed 2100000000.'
  fi
fi
git check-ref-format --branch "$SOURCE_BRANCH" >/dev/null
[[ "$(grep -c '^version:' pubspec.yaml)" == 1 ]] || fail 'pubspec.yaml must have exactly one version field.'
git diff --quiet && git diff --cached --quiet || fail 'Release preparation requires a clean checkout.'

release_version="$VERSION+$BUILD_NUMBER"
platforms=()
[[ "$ANDROID" == false ]] || platforms+=(android)
[[ "$IOS" == false ]] || platforms+=(ios)
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

# Include drafts in the snapshot so retries preserve their edited release notes.
gh api --paginate --slurp "repos/$GITHUB_REPOSITORY/releases?per_page=100" \
  | jq 'add // []' > "$work_dir/releases.json"

for platform in "${platforms[@]}"; do
  tag="$platform/v$release_version"
  existing=$(jq -c --arg tag "$tag" '.[] | select(.tag_name == $tag)' "$work_dir/releases.json")
  if [[ -n "$existing" && "$DRAFT" == true ]] && jq -e '.draft == false' <<< "$existing" >/dev/null; then
    fail "$tag is already published and cannot be prepared as a draft."
  fi
  if [[ -n "$existing" ]] && ! git show-ref --verify --quiet "refs/tags/$tag"; then
    fail "$tag has a release but no Git tag. Resolve it before retrying."
  fi
done

# Preparing the other platform later must reuse the same version/build's commit.
release_sha=''
for platform in android ios; do
  tag="$platform/v$release_version"
  if git show-ref --verify --quiet "refs/tags/$tag"; then
    tag_sha=$(git rev-parse "refs/tags/$tag^{commit}")
    [[ -z "$release_sha" || "$release_sha" == "$tag_sha" ]] || fail 'Platform tags point to different commits.'
    release_sha="$tag_sha"
  fi
done

if [[ -n "$release_sha" ]]; then
  # Reuse the original release commit even if the branch has advanced since a failed run.
  git merge-base --is-ancestor "$release_sha" HEAD || fail 'Existing release tags are not on the selected branch.'
  tagged_version=$(git show "$release_sha:pubspec.yaml" | awk '/^version:/ { print $2; exit }')
  [[ "${tagged_version%$'\r'}" == "$release_version" ]] || fail 'Existing release tag does not match pubspec.yaml.'
else
  RELEASE_VERSION="$release_version" awk '
    /^version:/ { print "version: " ENVIRON["RELEASE_VERSION"]; next }
    { print }
  ' pubspec.yaml > "$work_dir/pubspec.yaml"
  cp "$work_dir/pubspec.yaml" pubspec.yaml
  if ! git diff --quiet -- pubspec.yaml; then
    git config user.name 'github-actions[bot]'
    git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
    git add -- pubspec.yaml
    git commit -m "chore: bump app version to $release_version"
  fi
  release_sha=$(git rev-parse HEAD)
fi

tag_refs=()
for platform in "${platforms[@]}"; do
  tag="$platform/v$release_version"
  if ! git show-ref --verify --quiet "refs/tags/$tag"; then
    git tag "$tag" "$release_sha"
  fi
  tag_refs+=("refs/tags/$tag")
done
# A branch protection failure or concurrent push must not leave only some tags pushed.
git push --atomic origin "HEAD:refs/heads/$SOURCE_BRANCH" "${tag_refs[@]}"

# Create every missing release as a draft first, then publish if requested.
for platform in "${platforms[@]}"; do
  tag="$platform/v$release_version"
  existing=$(jq -c --arg tag "$tag" '.[] | select(.tag_name == $tag)' "$work_dir/releases.json")
  if [[ -n "$existing" ]]; then
    continue
  fi
  previous=''
  while IFS= read -r candidate; do
    if git show-ref --verify --quiet "refs/tags/$candidate" \
      && git merge-base --is-ancestor "refs/tags/$candidate^{commit}" "$release_sha"; then
      previous="$candidate"
      break
    fi
  done < <(jq -r --arg prefix "$platform/" --arg tag "$tag" '
    [.[] | select(.draft == false and .tag_name != $tag and (.tag_name | startswith($prefix)))]
    | sort_by(.published_at // .created_at) | reverse | .[].tag_name
  ' "$work_dir/releases.json")

  args=(release create "$tag" --repo "$GITHUB_REPOSITORY" --verify-tag --draft
    --title "$platform $VERSION ($BUILD_NUMBER)")
  if [[ -n "$previous" ]]; then
    args+=(--generate-notes --notes-start-tag "$previous")
  else
    # Without a platform predecessor, GitHub could choose the other platform's release.
    # Bootstrap with the full commit history instead of generating an incorrect range.
    {
      printf '## Changes\n\n'
      git log "$release_sha" --format='* %s (%h)'
    } > "$work_dir/$platform-notes.md"
    args+=(--notes-file "$work_dir/$platform-notes.md")
  fi
  gh "${args[@]}"
done

android_tag=''
ios_tag=''
for platform in "${platforms[@]}"; do
  tag="$platform/v$release_version"
  existing=$(jq -c --arg tag "$tag" '.[] | select(.tag_name == $tag)' "$work_dir/releases.json")
  if [[ "$DRAFT" == false ]] && { [[ -z "$existing" ]] || jq -e '.draft == true' <<< "$existing" >/dev/null; }; then
    gh release edit "$tag" --repo "$GITHUB_REPOSITORY" --draft=false
  fi
  if [[ "$platform" == android ]]; then
    android_tag="$tag"
  else
    ios_tag="$tag"
  fi
  url=$(gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json url --jq '.url')
  printf '* [%s](%s)\n' "$tag" "$url" >> "$GITHUB_STEP_SUMMARY"
done
{
  echo "release_sha=$release_sha"
  echo "android_tag=$android_tag"
  echo "ios_tag=$ios_tag"
} >> "$GITHUB_OUTPUT"
if [[ "$IOS" == true ]]; then
  echo 'iOS release entries are supported; iOS binary builds are not automated yet.' >> "$GITHUB_STEP_SUMMARY"
fi
