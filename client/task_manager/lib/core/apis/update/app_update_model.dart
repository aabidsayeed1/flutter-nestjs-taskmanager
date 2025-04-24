// To parse this JSON data, do
//
//     final appUpdateModel = appUpdateModelFromJson(jsonString);

import 'dart:convert';

AppUpdateModel appUpdateModelFromJson(String str) => AppUpdateModel.fromJson(json.decode(str));

class AppUpdateModel {
  final bool notifyUpdate;
  final bool forcedUpdate;
  final String latestVersion;
  final List<String> features;

  AppUpdateModel({
    this.notifyUpdate = false,
    this.forcedUpdate = false,
    this.latestVersion = '',
    this.features = const [],
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
        notifyUpdate: json["notifyUpdate"] ?? false,
        forcedUpdate: json["forceUpdate"] ?? false,
        latestVersion: json["latestVersion"] ?? '',
        features:
            json["features"] == null ? [] : List<String>.from(json["features"]!.map((x) => x)),
      );
}
