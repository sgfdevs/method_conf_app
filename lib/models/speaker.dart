import 'package:json_annotation/json_annotation.dart';

part 'speaker.g.dart';

@JsonSerializable()
class Speaker {
  String name;
  String? title;
  String? image;
  String? bio;
  String? professionalTitle;
  String? websiteURL;
  String? twitterUrl;
  String? twitter2Url;
  String? githubUrl;
  String? linkedinUrl;

  Speaker({
    required this.name,
    this.title,
    this.image,
    this.bio,
    this.professionalTitle,
    this.websiteURL,
    this.twitterUrl,
    this.twitter2Url,
    this.githubUrl,
    this.linkedinUrl,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);

  Map<String, dynamic> toJson() => _$SpeakerToJson(this);
}
