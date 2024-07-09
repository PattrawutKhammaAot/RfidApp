import 'dart:io';
import 'dart:math';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/main.dart';
import 'package:rfid/nativefunction/nativeFunction.dart';
import 'package:rfid/screens/addpage/addRfid_page.dart';
import 'package:rfid/screens/import_test/import_Test_Screen.dart';
import 'package:rfid/screens/reportpage/reportScreen.dart';
import 'package:rfid/screens/scan/scanScreen.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:rfid/screens/searchtag/serachtag_Screen.dart';
import 'package:rfid/screens/settings/setting_Screen.dart';

class HomePageControl extends StatefulWidget {
  const HomePageControl({super.key});

  @override
  State<HomePageControl> createState() => _HomePageControlState();
}

class _HomePageControlState extends State<HomePageControl> {
  List<tempRfidItemList> sendValue = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const AddRfidPage(),
      const SearchTagsScreen(),
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
      ),
      const SettingScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: GestureDetector(
          onTap: () {
            final db = appDb; //This should be a singleton
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DriftDbViewer(db)));
          },
          child: const Text(
            'RFID APP',
            style: TextStyle(color: whiteColor),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                exportTemplate();
              },
              child: Icon(
                Icons.info,
                color: whiteColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units),
            label: "${appLocalizations.menu_find_inventory}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: appLocalizations.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: appLocalizations.scan_title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: appLocalizations.menu_report,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: appLocalizations.menu_setting,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Future exportTemplate() async {
    await exportTxt();
    EasyLoading.showSuccess("Export Template Success");
  }

  Future<void> exportTxt() async {
    var directory = await AndroidPathProvider.downloadsPath;

    var selectDirectory = directory;
    var directoryExists = await Directory(selectDirectory).exists();
    if (!directoryExists) {
      await Directory(selectDirectory).create(recursive: true);
    }

    ///storage/emulated/0/Download

    var pathFile = '$selectDirectory/RFID_Template.txt';
    print(pathFile);
    var file = File(pathFile);
    var sink = file.openWrite();
    sink.write(
        '${Random().nextInt(10000)}${Random().nextInt(10000)}Example|\n');
    for (var i = 0; i < 10; i++) {
      sink.write(
          '${Random().nextInt(10000)}${Random().nextInt(10000)}Example|\n');
    }

    await sink.close();
  }
}
