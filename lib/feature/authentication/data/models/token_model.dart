import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(caseStyle: CaseStyle.snake, ignoreNullMembers: false, name: "data")
class TokenModel {
  String? accessToken;

  TokenModel({this.accessToken});

  Map<String, dynamic> toJson() {
    return {
      '"access_token"': '"$accessToken"',
    };
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
    );
  }
}
