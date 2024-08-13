import 'dart:async';

import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/scanrfid/models/ScanRfidCodeModel.dart';
import 'package:rfid/blocs/scanrfid/models/rfidItemListToJsonModel.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/config/appConfig.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/database/database.dart';
import 'package:rfid/main.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../config/appData.dart';
import '../../nativefunction/nativeFunction.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.onChange, this.receiveValue});
  final ValueChanged<List<tempRfidItemList>>? onChange;
  final List<tempRfidItemList>? receiveValue;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ZincDataSource? zincDataSource;
  List<Master_rfidData> itemList = [];

  List<tempRfidItemList> _addTable = [];
  FocusNode focusNode = FocusNode();
  FocusNode fakefocusNode = FocusNode();
  TextEditingController _controller = TextEditingController();

  bool isScanning = false;
  bool isASCII = false;
  bool isHide = true;

  @override
  void initState() {
    SDK_Function.init();
    BlocProvider.of<ScanrfidCodeBloc>(context).add(
      GetRfidItemListEvent(),
    );

    zincDataSource = ZincDataSource(process: []);
    Future.delayed(Duration(milliseconds: 500), () {
      SDK_Function.setASCII(true).then((value) {
        SDK_Function.getASCII().then((value) {
          print("get $value");
          isASCII = value;
          focusNode.requestFocus();
          fakefocusNode.requestFocus();
          isHide = false;
          setState(() {});
        });
      });
    });
    AppData.setPopupInfo("page_scan");
    super.initState();
  }

  @override
  void dispose() {
    SDK_Function.scan(false);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScanrfidCodeBloc, ScanrfidCodeState>(
            listener: (context, state) async {
          if (state.status == FetchStatus.fetching) {}
          if (state.status == FetchStatus.success) {
            if (state.data != null) {
              setState(() {
                itemList = state.data!;
                focusNode.requestFocus();
                fakefocusNode.requestFocus();
              });
            }
          }
          if (state.status == FetchStatus.failed) {}
        })
      ],
      child: Scaffold(
          body: KeyboardListener(
              focusNode: focusNode,
              autofocus: true,
              onKeyEvent: (e) async {
                const customKeyId = 0x110000020b;
                if (e is KeyDownEvent) {
                  if (e.logicalKey.keyId == customKeyId) {
                    await SDK_Function.scan(true);
                    isScanning = true;
                  } else {
                    await SDK_Function.scan(true);
                    isScanning = true;
                  }

                  setState(() {});
                } else if (e is KeyUpEvent) {
                  if (e.logicalKey.keyId == customKeyId) {
                    await SDK_Function.scan(false);
                    isScanning = false;
                  } else {
                    await SDK_Function.scan(false);
                    isScanning = false;
                  }
                  setState(() {});
                }
              },
              child: Column(
                children: [
                  Visibility(
                      visible: isHide,
                      child: Center(
                        child: SizedBox(
                          height: 1,
                          width: 1,
                          child: TextFormField(
                            focusNode: fakefocusNode,
                            controller: _controller,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 0,
                  ),
                  zincDataSource != null
                      ? FutureBuilder(
                          future:
                              SDK_Function.setTagScannedListener((epc, dbm) {
                            onEventScan(epc.trim(), dbm).then((value) async {
                              await SDK_Function.playSound();
                            });
                            // _addTable.add(tempRfidItemList(
                            //   rfid_tag: epc,
                            //   rssi: dbm,
                            //   status: "Found",
                            // ));
                            // setState(() {
                            //   zincDataSource =
                            //       ZincDataSource(process: _addTable);
                            // });
                          }),
                          builder: (context, snapshot) {
                            return Expanded(
                              flex: 2,
                              child: SfDataGrid(
                                onFilterChanged: (details) {
                                  print(details.column);
                                },
                                source: zincDataSource!,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                gridLinesVisibility: GridLinesVisibility.both,
                                selectionMode: SelectionMode.multiple,
                                allowPullToRefresh: true,
                                allowSorting: true,
                                allowColumnsResizing: true,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      visible: true,
                                      columnName: 'rfid_tag',
                                      label: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            appLocalizations.txt_number_tag,
                                          ),
                                        ),
                                      ),
                                      allowSorting: false),
                                  GridColumn(
                                      visible: true,
                                      columnName: 'RSSI',
                                      label: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'Rssi',
                                          ),
                                        ),
                                      ),
                                      allowSorting: true),
                                  GridColumn(
                                      visible: true,
                                      columnName: 'Status',
                                      label: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            appLocalizations.txt_status,
                                          ),
                                        ),
                                      ),
                                      allowSorting: false),
                                ],
                              ),
                            );
                          },
                        )
                      : SizedBox.fromSize(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  isScanning
                                      ? Colors.red
                                      : Colors.grey.withOpacity(0.5))),
                          onPressed: () async {
                            if (!isScanning) {
                              await SDK_Function.scan(true);
                              isScanning = true;
                            } else {
                              await SDK_Function.scan(false);
                              isScanning = false;
                            }
                            setState(() {});
                          },
                          child: Text(
                              isScanning
                                  ? appLocalizations.btn_stop_scan
                                  : appLocalizations.btn_start_scan,
                              style: TextStyle(color: Colors.white))),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.orangeAccent)),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          appLocalizations.popup_del_title_all),
                                      content: Text(
                                          appLocalizations.popup_del_sub_all),
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.redAccent)),
                                            onPressed: () {
                                              _addTable.clear();
                                              setState(() {
                                                zincDataSource =
                                                    ZincDataSource(process: []);
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              appLocalizations.btn_delete,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ));
                          },
                          child: Text(
                            appLocalizations.btn_clear_all,
                            style: TextStyle(color: Colors.white),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  _addTable.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.5))),
                          onPressed: () async {
                            if (_addTable.isNotEmpty) {
                              await exportDataToTxt();
                            } else {
                              EasyLoading.showError(appLocalizations.no_data);
                            }
                          },
                          child: Text(
                            appLocalizations.btn_export_data,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  zincDataSource != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(
                                          1.0,
                                          1.0,
                                        ),
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                        "${appLocalizations.txt_total}: ${_addTable.length}"),
                                    Text(
                                        "${appLocalizations.txt_found}: ${_addTable.where((element) => element.status == "Found").toList().length}"),
                                    Text(
                                        "${appLocalizations.txt_not_found}: ${_addTable.where((element) => element.status != "Found").toList().length}"),
                                    Row(
                                      children: <Widget>[
                                        Text("ASCII"),
                                        Checkbox(
                                          value: isASCII,
                                          onChanged: (value) async {
                                            await SDK_Function.setASCII(value!);
                                            setState(() {
                                              isASCII = value;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.fromSize(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ))),
    );
  }

  Future onEventScan(String _controller, String rssi) async {
    if (_controller.isNotEmpty) {
      var result = itemList
          .where((element) =>
              element.rfid_tag?.toUpperCase() == _controller.toUpperCase())
          .toList();
      // หาเจอ
      if (result.isNotEmpty) {
        //หา ใน Listตัวเองว่ามีหรือไม่
        if (_addTable
            .where((element) => element.rfid_tag == _controller)
            .toList()
            .isEmpty) {
          //ถ้าไม่มี

          _addTable.add(tempRfidItemList(
            rfid_tag: _controller,
            status: "Found",
            rssi: rssi,
          ));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller,
                statusRunning: "Found",
                rssi: rssi,
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
        } else if (_addTable
            .where((element) => element.rfid_tag == _controller)
            .toList()
            .isNotEmpty) {
          _addTable.removeWhere((element) => element.rfid_tag == _controller);
          _addTable.add(tempRfidItemList(
            rfid_tag: _controller,
            status: "Found",
            rssi: rssi,
          ));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller,
                statusRunning: "Found",
                rssi: rssi,
                updateDate: DateTime.now())),
          );
        } else if (_addTable
            .where((element) =>
                element.rfid_tag == _controller &&
                element.status == "Not Found")
            .toList()
            .isNotEmpty) {
          _addTable.removeWhere((element) => element.rfid_tag == _controller);
          _addTable.add(tempRfidItemList(
              rfid_tag: _controller, status: "Found", rssi: rssi));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller,
                statusRunning: "Found",
                rssi: rssi,
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
        }
      } else {
        if (_addTable
            .where((element) => element.rfid_tag == _controller)
            .toList()
            .isEmpty) {
          _addTable.add(tempRfidItemList(
              rfid_tag: _controller, status: "Not Found", rssi: rssi));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller,
                statusRunning: "Not Found",
                rssi: rssi,
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
        } else {
          _addTable.removeWhere((element) => element.rfid_tag == _controller);
          _addTable.add(tempRfidItemList(
              rfid_tag: _controller, status: "Not Found", rssi: rssi));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller,
                statusRunning: "Not Found",
                rssi: rssi,
                updateDate: DateTime.now())),
          );
        }
      }

      setState(() {
        zincDataSource = ZincDataSource(process: _addTable);
      });
      // for (var _rfid in itemList.itemListRfid!) {
      //   if (_rfid.rfidNumber == _controller.text) {

      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text("Data Found"),
      //       ),
      //     );
      //   } else {
      //     _addTable.add(ComboBoxModel(
      //       rfid_tag: _rfid.rfidNumber,
      //       status: "Not Found",
      //     ));
      //     setState(() {
      //       zincDataSource = ZincDataSource(process: _addTable);
      //     });
      //   }
      // }
    }
  }

  Future<void> exportDataToTxt() async {
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

        var pathFile = '$selectDirectory/rfid_scanned_$formattedDate.txt';
        var file = File(pathFile);
        var sink = file.openWrite();
        sink.write('tag|Rssi|status\n');
        for (var item in _addTable) {
          sink.write('${item.rfid_tag}|${item.rssi} dBm|${item.status}\n');
        }

        await sink.close();

        EasyLoading.showSuccess(appLocalizations.txt_export_success);
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
