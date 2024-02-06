// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


// void onReceive(BuildContext context, MethodChannel channel) {
//   channel.setMethodCallHandler((MethodCall call) async {
//     String action = call.method;
//     logI("onReceive , action: $action");

//     if (ACTION_CAPTURE_IMAGE == action) {
//       Uint8List? imageData = call.arguments[DECODE_CAPTURE_IMAGE_KEY];
//       if (imageData != null && imageData.isNotEmpty) {
//         // Assuming you have a method to convert Uint8List to Image widget
//         Image image = Image.memory(imageData);
//         // Assuming you have a method to send the image to the UI
//         sendMessageToUI(MSG_SHOW_SCAN_IMAGE, image);
//       } else {
//         logI("onReceive , ignore imageData: $imageData");
//       }
//     } else {
//       Uint8List? barcode = call.arguments[DECODE_DATA_TAG];
//       int barcodeLen = call.arguments[BARCODE_LENGTH_TAG] ?? 0;
//       int temp = call.arguments[BARCODE_TYPE_TAG] ?? 0;
//       String? barcodeStr = call.arguments[BARCODE_STRING_TAG];
//       if (mScanCaptureImageShow) {
//         // Send a broadcast or a message to request image decoding
//         // This is platform-specific and depends on how you handle platform channels
//         channel.invokeMethod(ACTION_DECODE_IMAGE_REQUEST);
//       }
//       logI("barcode type: $temp");
//       String scanResult = String.fromCharCodes(barcode!.sublist(0, barcodeLen));

//       scanResult = " length: $barcodeLen\nbarcode: $scanResult\nbytesToHexString: ${bytesToHexString(barcode)}\nbarcodeStr: $barcodeStr";
//       // Assuming you have a method to send the scan result to the UI
//       sendMessageToUI(MSG_SHOW_SCAN_RESULT, scanResult);
//     }
//   });
// }

// void logI(String message) {
//   // Implement logging functionality or use a package like 'logger'
//   debugPrint(message);
// }

// String bytesToHexString(Uint8List bytes) {
//   return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
// }

// void sendMessageToUI(int messageType, dynamic message) {
//   // Implement a method to send messages to the UI
//   // This could be using a StreamController, callback functions, or any other method
// }