// To parse this JSON data, do
//
//     final searchRfidModel = searchRfidModelFromJson(jsonString);

import 'dart:convert';

SearchRfidModel searchRfidModelFromJson(String str) =>
    SearchRfidModel.fromJson(json.decode(str));

String searchRfidModelToJson(SearchRfidModel data) =>
    json.encode(data.toJson());

class SearchRfidModel {
  List<RfidData>? data;
  bool? statusCode;
  String? message;

  SearchRfidModel({
    this.data,
    this.statusCode,
    this.message,
  });

  factory SearchRfidModel.fromJson(Map<String, dynamic> json) =>
      SearchRfidModel(
        data: json['data'] != null
            ? List<RfidData>.from(json["data"].map((x) => RfidData.fromJson(x)))
            : null,
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status_code": statusCode,
        "message": message,
      };
}

class RfidData {
  String? tagId;
  String? rssi;
  String? status;

  RfidData({
    this.tagId,
    this.rssi,
    this.status,
  });

  factory RfidData.fromJson(Map<String, dynamic> json) => RfidData(
        tagId: json["tag_id"],
        rssi: json["rssi"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {"tag_id": tagId, "rssi": rssi, "status": status};
}
