// To parse this JSON data, do
//
//     final totalScanModel = totalScanModelFromJson(jsonString);

import 'dart:convert';

TotalScanModel totalScanModelFromJson(String str) =>
    TotalScanModel.fromJson(json.decode(str));

String totalScanModelToJson(TotalScanModel data) => json.encode(data.toJson());

class TotalScanModel {
  int? totalMaster;
  int? totalLoss;
  int? totalFound;
  bool? statusCode;
  String? message;

  TotalScanModel({
    this.totalMaster,
    this.totalLoss,
    this.totalFound,
    this.statusCode,
    this.message,
  });

  TotalScanModel copyWith({
    int? totalMaster,
    int? totalLoss,
    int? totalFound,
    bool? statusCode,
    String? message,
  }) =>
      TotalScanModel(
        totalMaster: totalMaster ?? this.totalMaster,
        totalLoss: totalLoss ?? this.totalLoss,
        totalFound: totalFound ?? this.totalFound,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory TotalScanModel.fromJson(Map<String, dynamic> json) => TotalScanModel(
        totalMaster: json["total_master"],
        totalLoss: json["total_loss"],
        totalFound: json["total_found"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "total_master": totalMaster,
        "total_loss": totalLoss,
        "total_found": totalFound,
        "status_code": statusCode,
        "message": message,
      };
}
