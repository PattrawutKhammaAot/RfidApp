// To parse this JSON data, do
//
//     final scanRfidCodeModel = scanRfidCodeModelFromJson(jsonString);

import 'dart:convert';

ScanRfidCodeModel scanRfidCodeModelFromJson(String str) =>
    ScanRfidCodeModel.fromJson(json.decode(str));

String scanRfidCodeModelToJson(ScanRfidCodeModel data) =>
    json.encode(data.toJson());

class ScanRfidCodeModel {
  String? rfidNumber;
  String? statusRunning;
  DateTime? updateDate;

  ScanRfidCodeModel({
    this.rfidNumber,
    this.statusRunning,
    this.updateDate,
  });

  ScanRfidCodeModel copyWith({
    String? rfidNumber,
    String? statusRunning,
    DateTime? updateDate,
  }) =>
      ScanRfidCodeModel(
        rfidNumber: rfidNumber ?? this.rfidNumber,
        statusRunning: statusRunning ?? this.statusRunning,
        updateDate: updateDate ?? this.updateDate,
      );

  factory ScanRfidCodeModel.fromJson(Map<String, dynamic> json) =>
      ScanRfidCodeModel(
        rfidNumber: json["rfid_number"],
        statusRunning: json["status_running"],
        updateDate: json["update_date"] == null
            ? null
            : DateTime.parse(json["update_date"]),
      );

  Map<String, dynamic> toJson() => {
        "rfid_number": rfidNumber,
        "status_running": statusRunning,
        "update_date": updateDate?.toIso8601String(),
      };
}
