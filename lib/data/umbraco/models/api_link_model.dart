import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';
import 'package:method_conf_app/data/umbraco/utils.dart';
import 'package:method_conf_app/env.dart';

part 'api_link_model.g.dart';

@JsonSerializable()
class ApiLinkModel {
  String? url;
  String? queryString;
  String? title;
  String? target;
  String? destinationId;
  String? destinationType;
  ApiContentRouteModel? route;
  @JsonKey(readValue: readLowerCase)
  LinkType linkType;

  ApiLinkModel({
    this.url,
    this.queryString,
    this.title,
    this.target,
    this.destinationId,
    this.destinationType,
    this.route,
    required this.linkType,
  });

  String? get fullUrl {
    final path = route?.path;
    final u = url;
    return switch (linkType) {
      LinkType.content when path != null => _getWithQs(_withSitePrefix(path)),
      LinkType.external when u != null => u,
      LinkType.media when u != null => _getWithQs(_withCmsPrefix(u)),
      _ => null,
    };
  }

  String _withCmsPrefix(String urlStr) {
    return Env.umbracoBaseUrl + urlStr;
  }

  String _withSitePrefix(String urlStr) {
    return Env.methodBaseUrl + urlStr;
  }

  String _getWithQs(String urlStr) {
    final qs = queryString;
    return qs != null ? urlStr + qs : urlStr;
  }

  factory ApiLinkModel.fromJson(Map<String, dynamic> json) =>
      _$ApiLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiLinkModelToJson(this);
}

enum LinkType { content, external, media }
