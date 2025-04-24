// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppModel {
  final String strVersionName;
  final String strBuildNumber;
  final String strOS;
  final String strOSVersion;

  const AppModel(
      {required this.strVersionName,
      required this.strBuildNumber,
      required this.strOS,
      required this.strOSVersion});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'strVersionName': strVersionName,
      'strBuildNumber': strBuildNumber,
      'strOS': strOS,
      'strOSVersion': strOSVersion,
    };
  }



  String toJson() => json.encode(toMap());

}
