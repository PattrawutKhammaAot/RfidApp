// To parse this JSON data, do
//
//     final rfidItemList = rfidItemListFromJson(jsonString);

import 'dart:convert';

RfidItemList rfidItemListFromJson(String str) =>
    RfidItemList.fromJson(json.decode(str));

String rfidItemListToJson(RfidItemList data) => json.encode(data.toJson());

class RfidItemList {
  bool? statusCode;
  String? message;
  List<listData>? itemListRfid;

  RfidItemList({
    this.statusCode,
    this.message,
    this.itemListRfid,
  });

  RfidItemList copyWith({
    bool? statusCode,
    String? message,
    List<listData>? itemListRfid,
  }) =>
      RfidItemList(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        itemListRfid: itemListRfid ?? this.itemListRfid,
      );

  factory RfidItemList.fromJson(Map<String, dynamic> json) => RfidItemList(
        statusCode: json["status_code"],
        message: json["message"],
        itemListRfid: json["data"] == null
            ? []
            : List<listData>.from(
                json["data"]!.map((x) => listData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "data": itemListRfid == null
            ? []
            : List<dynamic>.from(itemListRfid!.map((x) => x.toJson())),
      };
}

class listData {
  String? rfidNumber;
  DateTime? createDate;

  listData({
    this.rfidNumber,
    this.createDate,
  });

  listData copyWith({
    String? rfidNumber,
    DateTime? createDate,
  }) =>
      listData(
        rfidNumber: rfidNumber ?? this.rfidNumber,
        createDate: createDate ?? this.createDate,
      );

  factory listData.fromJson(Map<String, dynamic> json) => listData(
        rfidNumber: json["rfid_number"],
        createDate: json["create_date"] == null
            ? null
            : DateTime.parse(json["create_date"]),
      );

  Map<String, dynamic> toJson() => {
        "rfid_number": rfidNumber,
        "create_date": createDate?.toIso8601String(),
      };
}
