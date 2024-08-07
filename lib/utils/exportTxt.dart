import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

//ไม่ได้ใช้ตัวอย่างเฉยๆ
class ExportToTxt {
  Future<void> exportDataToTxt(List<dynamic> itemModel) async {
    try {
      await Permission.manageExternalStorage.request();
      if (await Permission.manageExternalStorage.request().isGranted) {
        var directory = await AndroidPathProvider.downloadsPath;

        var selectDirectory = directory;
        var directoryExists = await Directory(selectDirectory).exists();
        if (!directoryExists) {
          await Directory(selectDirectory).create(recursive: true);
        }

        var now = DateTime.now();
        var formatter = DateFormat('dd_MM_yyyy_HH_mm_ss');
        var formattedDate = formatter.format(now);

        var pathFile = '$selectDirectory/rfid_report_$formattedDate.txt';
        var file = File(pathFile);
        var sink = file.openWrite();
        sink.write('tag|Rssi|status\n');
        for (var item in itemModel) {
          sink.write('${item.tagId}|${item.rssi} dBm|${item.status}\n');
        }

        await sink.close();
        print(pathFile);
      } else {
        openAppSettings();
      }
      print("object");
    } catch (e, s) {
      print("$e$s");
    }
  }
}
