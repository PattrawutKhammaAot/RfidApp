// To parse this JSON data, do
//
//     final defaultResponse = defaultResponseFromJson(jsonString);

import 'dart:convert';

DefaultResponse defaultResponseFromJson(String str) =>
    DefaultResponse.fromJson(json.decode(str));

String defaultResponseToJson(DefaultResponse data) =>
    json.encode(data.toJson());

class DefaultResponse {
  String? message;
  bool? statusCode;

  DefaultResponse({
    this.message,
    this.statusCode,
  });

  DefaultResponse copyWith({
    String? message,
    bool? statusCode,
  }) =>
      DefaultResponse(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
      );

  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      DefaultResponse(
        message: json["message"],
        statusCode: json["status_code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
      };
}
