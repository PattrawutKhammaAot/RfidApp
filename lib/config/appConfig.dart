import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String BASE_API_URL = "http://demo.oga.co.th/rfid_app/";
//String BAS_API_URL_LOCAL = "http://192.168.1.5:3000/rfid_app/";

class ApiConfig {
  static Map<String, dynamic> HEADER({String? Authorization}) {
    if (Authorization != null) {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $Authorization'
      };
    } else {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
      };
    }
  }

  static String RFID_TAG_LIST = "${BASE_API_URL}api/ScanrfidCode/rfidTagList";
  static String SCAN_RFID_CODE = "${BASE_API_URL}api/ScanrfidCode/ScanrfidCode";
  static String GET_TOTAL_SCAN = "${BASE_API_URL}api/ScanrfidCode/getTotalScan";
  static String IMPORT_RFID_TAG =
      "${BASE_API_URL}api/ScanrfidCode/importMasterRfidTag";

  static String SERACH_TAG_RFID = "${BASE_API_URL}api/ScanrfidCode/searchRfid";
  static String DELETE_SERACH_TAG_RFID =
      "${BASE_API_URL}api/ScanrfidCode/DeleteTagRunning";
  static String DELETE_MASTER_TAG_RFID =
      "${BASE_API_URL}api/ScanrfidCode/DeleteMaster";
}

void offKeyBoard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
