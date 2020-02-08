import 'package:json_annotation/json_annotation.dart';

part 'sponsor.g.dart';

@JsonSerializable()
class Sponsor {
  String title;
  String url;
  String image;
  bool mobileSponsor;
  String background;

  Sponsor({
    this.title,
    this.url,
    this.image,
    this.mobileSponsor,
    this.background,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorToJson(this);
}
