// To parse this JSON data, do
//
//     final importRfidCodeModel = importRfidCodeModelFromJson(jsonString);

import 'dart:convert';

ImportRfidCodeModel importRfidCodeModelFromJson(String str) =>
    ImportRfidCodeModel.fromJson(json.decode(str));

String importRfidCodeModelToJson(ImportRfidCodeModel data) =>
    json.encode(data.toJson());

class ImportRfidCodeModel {
  String? rfidTag;
  DateTime? createDate;

  ImportRfidCodeModel({
    this.rfidTag,
    this.createDate,
  });

  ImportRfidCodeModel copyWith({
    String? rfidTag,
    DateTime? createDate,
  }) =>
      ImportRfidCodeModel(
        rfidTag: rfidTag ?? this.rfidTag,
        createDate: createDate ?? this.createDate,
      );

  factory ImportRfidCodeModel.fromJson(Map<String, dynamic> json) =>
      ImportRfidCodeModel(
        rfidTag: json["rfid_tag"],
        createDate: json["create_date"] == null
            ? null
            : DateTime.parse(json["create_date"]),
      );

  Map<String, dynamic> toJson() => {
        "rfid_tag": rfidTag,
        "create_date": createDate?.toIso8601String(),
      };
}
