import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfid/main.dart';

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
      print("result: $result");
      return result;
    } catch (e) {
      print('Error123: $e');
      return 'Error';
    }
  }

  static Future<dynamic> setPower(int setpower) async {
    try {
      print("Power of setpower: $setpower");
      dynamic result =
          await platform.invokeMethod('SetPower', {"power": setpower});
      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return 'Error';
    }
  }

  static Future<dynamic> getLengthASCII() async {
    try {
      dynamic result = await platform.invokeMethod('GetLengthASCII');

      return result;
    } catch (e) {
      print('Error GetLength: $e');
      return 'Error';
    }
  }

  static Future<dynamic> setLengthASCII(int setLengthASCII) async {
    try {
      dynamic result = await platform
          .invokeMethod('SetLengthASCII', {"length": setLengthASCII});
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
      print('Error Scanned: $e');
      return 'Error';
    }

    return "Listening";
  }

  static Future<void> init() async {
    try {
      var result = await getPower();
      if (result == 'Error' || result == -1) {
        await platform.invokeMethod('initScanner');
        EasyLoading.show(status: appLocalizations.txt_Initializing);
        setPower(33);
        await Future.delayed(Duration(seconds: 2));

        EasyLoading.showSuccess(appLocalizations.txt_Initialized);
      }
    } catch (e) {
      print('Error123: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<dynamic> closeScanner() async {
    try {
      dynamic result = await platform.invokeMethod('CloseScanner');

      return result;
    } catch (e) {
      print('Error CloseScanner: $e');
      return 'Error';
    }
  }

  static Future<dynamic> openScanner() async {
    try {
      dynamic result = await platform.invokeMethod('OpenScanner');

      return result;
    } catch (e) {
      print('Error OpenScanner: $e');
      return 'Error';
    }
  }

  static Future<dynamic> checkScanner() async {
    try {
      dynamic result = await platform.invokeMethod('CheckScanner');

      if (result) {
        return result;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      print("Error from platform channel: ${e.code}, ${e.message}");
      return null;
    }
  }

  static Future<dynamic> getTriggerLockState() async {
    try {
      dynamic result = await platform.invokeMethod('getTriggerLockState');
      print("result $result");
      if (result) {
        return result;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      print("Error from platform channel: ${e.code}, ${e.message}");
      return null;
    }
  }

  static Future<void> playSound() async {
    try {
      await platform.invokeMethod('usedSound');
    } on PlatformException catch (e) {
      print("Error from platform channel: ${e.code}, ${e.message}");
      return null;
    }
  }

  String hexToAscii(String hexStr) {
    StringBuffer output = StringBuffer();
    for (int i = 0; i < hexStr.length; i += 2) {
      String hexPair = hexStr.substring(i, i + 2);
      int decimalValue = int.parse(hexPair, radix: 16);

      // ตรวจสอบว่าค่าที่แปลงได้อยู่ในช่วง ASCII ที่สามารถพิมพ์ได้หรือไม่
      if (decimalValue >= 32 && decimalValue <= 126) {
        output.write(String.fromCharCode(decimalValue));
      }
    }
    return output.toString();
  }
}
