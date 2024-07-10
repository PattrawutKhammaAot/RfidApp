import 'dart:io';
import 'dart:math';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/config/appData.dart';
import 'package:rfid/database/database.dart';
import 'package:rfid/main.dart';
import 'package:rfid/nativefunction/nativeFunction.dart';
import 'package:rfid/screens/addpage/addRfid_page.dart';
import 'package:rfid/screens/import_test/import_Test_Screen.dart';
import 'package:rfid/screens/reportpage/reportScreen.dart';
import 'package:rfid/screens/scan/scanScreen.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:rfid/screens/searchtag/serachtag_Screen.dart';
import 'package:rfid/screens/settings/setting_Screen.dart';

import '../../blocs/search_rfid/search_rfid_bloc.dart';

class HomePageControl extends StatefulWidget {
  const HomePageControl({super.key});

  @override
  State<HomePageControl> createState() => _HomePageControlState();
}

class _HomePageControlState extends State<HomePageControl> {
  List<tempRfidItemList> sendValue = [];
  int _selectedIndex = 0;
  List<String> _list = [
    'page_settings',
    'page_scan',
    'page_search',
    'page_report',
    'page_inventory'
  ];
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
      ScanScreen(
        onChange: (value) {
          setState(() {
            sendValue = value;
          });
        },
        receiveValue: sendValue,
      ),
      const SearchTagsScreen(),
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
          _selectedIndex == 2
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(appLocalizations.popup_del_title_all),
                              content: Text(appLocalizations.popup_del_sub_all),
                              actions: [
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.blue)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      appLocalizations.btn_cancel,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.redAccent)),
                                    onPressed: () async {
                                      final item =
                                          await appDb.search_tag_rfid('');
                                      context.read<SearchRfidBloc>().add(
                                          DeleteAllEvent(item
                                              .map((e) => e.key_id)
                                              .toList()));
                                      // itemModel.clear();

                                      setState(() {});

                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      appLocalizations.btn_delete,
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ));
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ))
              : SizedBox.fromSize(),
          _selectedIndex == 1 || _selectedIndex == 3
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () async {
                        await exportTemplate();
                      },
                      child: FaIcon(
                        FontAwesomeIcons.fileExport,
                        color: whiteColor,
                      )),
                )
              : SizedBox.fromSize(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                if (_selectedIndex == 0) {
                  showInfoInventory();
                  // FindInventory
                } else if (_selectedIndex == 1) {
                  showinfoScan();
                  //scan
                } else if (_selectedIndex == 2) {
                  showInfoSearch();
                  //search
                } else if (_selectedIndex == 3) {
                  showInfoReport();
                  //report
                } else if (_selectedIndex == 4) {
                  showInfoSetting();
                  //settings
                }

                // exportTemplate();
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
            icon: Icon(Icons.search_rounded),
            label: "${appLocalizations.menu_find_inventory}",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.piggyBank),
            label: appLocalizations.scan_title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: appLocalizations.search,
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
    EasyLoading.showSuccess(appLocalizations.btn_export_template);
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

  void showInfoInventory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${appLocalizations.txt_menu_title} ${appLocalizations.menu_find_inventory}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1) ${appLocalizations.hint_add_rfid} - สามารถ Key in data หรือ Scan Barcode เพื่อ Input data ที่ต้องการค้นหา"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "2) ${appLocalizations.btn_export_data} - สามารถ Export ข้อมูลเก็บไว้บนตัวเครื่องในรูปแบบ Text File"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "3) ${appLocalizations.btn_clear_all} - กดเพื่อ Clear ข้อมูลทั้งหมดที่แสดง"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "4) Filter - ใช้เพื่อเรียงลำดับค่า Tag ที่ใกล้ที่สุดหรือไกลที่สุด"),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "5) Play button - กดเพื่ออ่านแบบต่อเนื่องแทนการกดปุ่ม Trigger gun"),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.blue,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(24)),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appLocalizations.btn_ok,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }

  void showInfoSearch() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${appLocalizations.txt_menu_title} ${appLocalizations.menu_search}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1) ${appLocalizations.txt_serach_field} - ใช้เพื่อค้าหาข้อมูล Tag ที่สแกน"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "2) ${appLocalizations.btn_export_data} - สามารถ Export ข้อมูลเก็บไว้บนตัวเครื่องในรูปแบบ Text File"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "3) ${appLocalizations.txt_select} - สามารถกดเพื่อดูสถานะข้อมูล ${appLocalizations.txt_found} / ${appLocalizations.txt_not_found} "),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "4) Filter - ใช้เพื่อเรียงลำดับค่า Tag ที่ใกล้ที่สุดหรือไกลที่สุด"),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("5) Delete button - กดเพื่อลบข้อมูลทั้งหมด"),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appLocalizations.btn_ok,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }

  void showinfoScan() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${appLocalizations.txt_menu_title} ${appLocalizations.scan_title}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1) ${appLocalizations.btn_start_scan} - กดเพื่อ Scan Tag ทั้งหมดที่อยู่ใน Area ที่ Scan"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "2) ${appLocalizations.btn_clear_all} - กดเพื่อ Clear ข้อมูลทั้งหมดที่แสดง"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "3) ${appLocalizations.btn_export_data} - สามารถ Export ข้อมูลเก็บไว้บนตัวเครื่องในรูปแบบ Text File"),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: FaIcon(
                      FontAwesomeIcons.fileExport,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appLocalizations.btn_ok,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }

  void showInfoReport() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${appLocalizations.txt_menu_title} ${appLocalizations.menu_report}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1) ${appLocalizations.txt_master} - ข้อมูล Tag ที่ทำการ Import ทั้งหมดที่ต้องการตรวจสอบ"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "2) ${appLocalizations.txt_found} - ข้อมูล Tag ที่ Scan แล้วพบข้อมูลในระบบ ที่มีการนำเข้าจาก ${appLocalizations.txt_master}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "3) ${appLocalizations.txt_not_scan} - ข้อมูลที่ Tag ที่ยังไม่ได้ Scan ที่มีการนำเข้าจาก ${appLocalizations.txt_master}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "4) ${appLocalizations.txt_not_found} - ข้อมูลที่ Scan เจอใน Area แต่ไม่มีข้อมูลในระบบ ที่มีการนำเข้าจาก ${appLocalizations.txt_master}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "5) ${appLocalizations.btn_import_data} - กดเพื่อ Import ข้อมูลจาก Text File เข้ามาใน Application เพื่อทำการค้นหา"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "6) ${appLocalizations.btn_export_data} - สามารถ Export ข้อมูลเก็บไว้บนตัวเครื่องในรูปแบบ Text File"),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: FaIcon(
                      FontAwesomeIcons.fileExport,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appLocalizations.btn_ok,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }

  void showInfoSetting() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${appLocalizations.txt_menu_title} ${appLocalizations.menu_setting}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1) ${appLocalizations.txt_select_lang_title} - ใช้สำหรับเปลี่ยนภาษาของ Application"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "2) ${appLocalizations.btn_set_power} - ใช้เพื่อปรับค่า DB หรือความแรงของคลื่นในการสแกน"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "3) ${appLocalizations.btn_set_length_ASCII} - ใช้เพื่อปรับ Maximum การอ่านค่าในแต่ละ Digit"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "4) ${appLocalizations.btn_swtich_scanner} - ใช้เพื่อ เปิด-ปิด หัวอ่าน PDA"),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      appLocalizations.btn_ok,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }
}
