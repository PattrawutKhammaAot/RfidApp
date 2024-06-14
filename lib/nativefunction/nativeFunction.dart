import 'package:flutter/services.dart';

class SDK_Function {
  static const platform = MethodChannel("com.example/customChannel");

  static Future<String> setScanHeader() async {
    try {
      bool status = false;
      status = !status;
      final result =
          await platform.invokeMethod('Scanned', {"statusTrg": true});
      print(result);
      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<dynamic> getASCII() async {
    try {
      dynamic result = await platform.invokeMethod('GetASCII');

      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<String> setASCII(bool isACSII) async {
    try {
      bool status = false;
      status = !status;
      final result =
          await platform.invokeMethod('SetASCII', {"isASCII": isACSII});
      print(result);
      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<dynamic> scan(bool status) async {
    try {
      dynamic result;
      if (status) {
        result = await platform.invokeMethod('startInventory');
      } else {
        result = await platform.invokeMethod('stopInventory');
      }

      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<dynamic> getPower() async {
    try {
      dynamic result = await platform.invokeMethod('GetPower');

      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<dynamic> setPower(int setpower) async {
    try {
      dynamic result =
          await platform.invokeMethod('SetPower', {"power": setpower});
      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return 'Error';
    }
  }

  static Future<String> setTagScannedListener(
      Function(String epc, String rssi) onTagScanned) async {
    try {
      platform.setMethodCallHandler((MethodCall call) async {
        if (call.method == 'onTagScanned') {
          String epc = call.arguments['epc'];
          String rssi = call.arguments['rssi'];

          onTagScanned(epc, rssi);
          return epc;
        }
        return null;
      });
    } catch (e, s) {
      print('Error123: $e');
      return 'Error';
    }

    return "Listening";
  }
}
