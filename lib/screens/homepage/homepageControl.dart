import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/screens/reportpage/reportScreen.dart';
import 'package:rfid/screens/scan/scanScreen.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';

class HomePageControl extends StatefulWidget {
  const HomePageControl({super.key});

  @override
  State<HomePageControl> createState() => _HomePageControlState();
}

class _HomePageControlState extends State<HomePageControl> {
  List<tempRfidItemList> sendValue = [];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ScanScreen(
        onChange: (value) {
          setState(() {
            sendValue = value;
          });
        },
        receiveValue: sendValue,
      ),
      ReportScreen(
        receiveValue: sendValue,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'RFID APP',
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () async {
                await exportTemplate();
              },
              child: Icon(
                Icons.info,
                color: whiteColor,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Import',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        onTap: _onItemTapped,
      ),
    );
  }

  Future exportTemplate() async {
    var data = 'EX|\n';
    data += 'EX|\n';
    data += 'EX|\n';
    data += 'EX|\n';
    data += 'EX|\n';
    data += 'EX|\n';
    data += 'EX|\n';
    data += 'EX|';

    await exportTxt(data: data, fileName: "RFID_Template");
    EasyLoading.showSuccess("Export Template Success");
  }

  Future<void> exportTxt({String? data, String? fileName}) async {
    if (await Permission.storage.request().isGranted) {
      var directory = await AndroidPathProvider.downloadsPath;

      var selectDirectory = directory;
      var directoryExists = await Directory(selectDirectory).exists();
      if (!directoryExists) {
        await Directory(selectDirectory).create(recursive: true);
      }

      ///storage/emulated/0/Download
      var filename = fileName;
      var pathFile = '$selectDirectory/$filename.txt';

      var file = File(pathFile);
      await file.writeAsString(data!);
    }
  }
}
