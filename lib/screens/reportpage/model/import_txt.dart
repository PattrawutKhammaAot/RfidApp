// To parse this JSON data, do
//
//     final importTextModel = importTextModelFromJson(jsonString);

import 'dart:convert';

ImportTextModel importTextModelFromJson(String str) =>
    ImportTextModel.fromJson(json.decode(str));

String importTextModelToJson(ImportTextModel data) =>
    json.encode(data.toJson());

class ImportTextModel {
  String? rfidTag;
  DateTime? createDate;

  ImportTextModel({
    this.rfidTag,
    this.createDate,
  });

  ImportTextModel copyWith({
    String? rfidTag,
    DateTime? createDate,
  }) =>
      ImportTextModel(
        rfidTag: rfidTag ?? this.rfidTag,
        createDate: createDate ?? this.createDate,
      );

  factory ImportTextModel.fromJson(Map<String, dynamic> json) =>
      ImportTextModel(
        rfidTag: json["rfid_tag"],
        createDate: json["create_date"],
      );

  Map<String, dynamic> toJson() => {
        "rfid_tag": rfidTag,
        "create_date": createDate,
      };
}
