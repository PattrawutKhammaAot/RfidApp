import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/nativefunction/nativeFunction.dart';
import 'package:rfid/screens/import_test/import_Test_Screen.dart';
import 'package:rfid/screens/reportpage/reportScreen.dart';
import 'package:rfid/screens/scan/scanScreen.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:rfid/screens/searchtag/serachtag_Screen.dart';

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
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                var currentPower = await SDK_Function.getPower();
                modalPickerNumber(currentPower);
              },
              child: Icon(
                Icons.settings,
                color: whiteColor,
                size: 30,
              ),
            ),
          ),
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
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Search Tags',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Scan Tags',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        onTap: _onItemTapped,
      ),
    );
  }

  Future exportTemplate() async {
    var data = 'EX|';
    data += 'EX|';
    data += 'EX|';
    data += 'EX|';
    data += 'EX|';
    data += 'EX|';
    data += 'EX|';
    data += 'EX|';

    await exportTxt(data: data, fileName: "RFID_Template");
    EasyLoading.showSuccess("Export Template Success");
  }

  Future<void> exportTxt({String? data, String? fileName}) async {
    var directory = await AndroidPathProvider.downloadsPath;

    var selectDirectory = directory;
    var directoryExists = await Directory(selectDirectory).exists();
    if (!directoryExists) {
      await Directory(selectDirectory).create(recursive: true);
    }

    ///storage/emulated/0/Download
    var filename = fileName;
    var pathFile = '$selectDirectory/$filename.txt';
    print(pathFile);
    var file = File(pathFile);
    await file.writeAsString(data!);
  }

  void modalPickerNumber(dynamic power) {
    // Mock data
    List<int> numbers = List<int>.generate(33, (i) => i + 1);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10, width: double.infinity),
              const Center(
                  child: Text(
                "Select Power",
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Current Power : $power",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Power : ${numbers[index]}'),
                      onTap: () async {
                        var result =
                            await SDK_Function.setPower(numbers[index]);
                        EasyLoading.showSuccess(result);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
