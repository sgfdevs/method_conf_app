import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

// CI supplies environment variables; local builds can use android/key.properties.
fun signingProperty(name: String, environmentVariable: String): String? =
    System.getenv(environmentVariable) ?: keystoreProperties.getProperty(name)

val validateReleaseSigning = tasks.register("validateReleaseSigning") {
    doLast {
        val required = mapOf(
            "storeFile" to "ANDROID_KEYSTORE_PATH",
            "storePassword" to "ANDROID_KEYSTORE_PASSWORD",
            "keyAlias" to "ANDROID_KEY_ALIAS",
            "keyPassword" to "ANDROID_KEY_PASSWORD",
        )
        val missing = required.filter { (property, variable) ->
            signingProperty(property, variable).isNullOrBlank()
        }
        check(missing.isEmpty()) {
            "Missing release signing credentials: ${missing.keys.joinToString()}. " +
                "Set android/key.properties or the corresponding ANDROID_* environment variables."
        }
    }
}

tasks.matching { it.name == "preReleaseBuild" }.configureEach {
    dependsOn(validateReleaseSigning)
}

android {
    namespace = "com.sgfdevs.methodConfApp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.sgfdevs.methodConfApp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = signingProperty("storeFile", "ANDROID_KEYSTORE_PATH")?.let {
                rootProject.file(it)
            }
            storePassword = signingProperty("storePassword", "ANDROID_KEYSTORE_PASSWORD")
            keyAlias = signingProperty("keyAlias", "ANDROID_KEY_ALIAS")
            keyPassword = signingProperty("keyPassword", "ANDROID_KEY_PASSWORD")
        }
    }

    buildTypes {
        release {
            // Missing release credentials must fail signing, never fall back to the debug key.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
