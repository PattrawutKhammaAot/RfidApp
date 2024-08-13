import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/master/master_rfid_bloc.dart';
import 'package:rfid/blocs/tempMaster/temp_master_bloc.dart';
import 'package:rfid/config/appData.dart';
import 'package:rfid/main.dart';
import 'package:rfid/nativefunction/nativeFunction.dart';

import '../../blocs/scanrfid/models/importRfidCodeModel.dart';
import '../../database/database.dart';

class AddRfidPage extends StatefulWidget {
  const AddRfidPage({super.key});

  @override
  State<AddRfidPage> createState() => _AddRfidPageState();
}

class _AddRfidPageState extends State<AddRfidPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<TempMasterRfidData> itemList = [];
  List<TempMasterRfidData> temp_itemList = [];
  bool isScanning = false;
  bool isFilter = false;

  @override
  void initState() {
    SDK_Function.init();
    SDK_Function.setASCII(true);
    focusNode.requestFocus();
    BlocProvider.of<TempMasterBloc>(context).add(
      GetTempMasterEvent(),
    );
    AppData.setPopupInfo("page_inventory");
    Future.delayed(Duration(milliseconds: 500), () async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() async {
    SDK_Function.scan(false);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<TempMasterBloc, TempMasterState>(
              listener: (context, state) async {
            print(state.status);
            if (state.status == FetchStatus.success) {
              itemList = state.data!;
              temp_itemList = itemList;
              setState(() {});
            }
            if (state.status == FetchStatus.saved) {
              context.read<TempMasterBloc>().add(GetTempMasterEvent());
            }
            if (state.status == FetchStatus.deleteSuccess) {
              print("object");
              context.read<TempMasterBloc>().add(GetTempMasterEvent());
            }
            if (state.status == FetchStatus.failed) {
              itemList = [];
              temp_itemList = itemList;
              setState(() {});
            }
          })
        ],
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: isScanning ? Colors.red : Colors.blue,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24)),
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
              child: Icon(
                isScanning ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
              )),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: appLocalizations.hint_add_rfid,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () async {
                          if (searchController.text.isNotEmpty) {
                            if (itemList
                                .where((qry) =>
                                    qry.rfid_tag ==
                                    searchController.text.trim().toUpperCase())
                                .isNotEmpty) {
                              EasyLoading.showError(
                                  appLocalizations.txt_duplicate_edit);
                            } else {
                              context.read<TempMasterBloc>().add(
                                  AddTempMasterEvent(TempMasterRfidData(
                                      key_id: 0,
                                      rfid_tag: searchController.text
                                          .trim()
                                          .toUpperCase(),
                                      status: "Not Found",
                                      created_at: DateTime.now())));
                            }

                            searchController.clear();
                            focusNode.requestFocus();
                          }

                          setState(() {});
                        },
                      )),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      itemList = temp_itemList
                          .where((element) =>
                              element.rfid_tag!.contains(value.toUpperCase()))
                          .toList();
                      setState(() {});
                    } else {
                      itemList = temp_itemList;
                      setState(() {});
                    }
                  },
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      if (itemList
                          .where((qry) =>
                              qry.rfid_tag == value.trim().toUpperCase())
                          .isNotEmpty) {
                        EasyLoading.showError(
                            appLocalizations.txt_duplicate_edit);
                      } else {
                        context.read<TempMasterBloc>().add(AddTempMasterEvent(
                            TempMasterRfidData(
                                key_id: 0,
                                rfid_tag: value.trim().toUpperCase(),
                                status: "Not Found",
                                rssi: null,
                                created_at: DateTime.now())));
                      }

                      searchController.clear();
                      focusNode.requestFocus();
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (itemList.isNotEmpty) {
                        await exportDataToTxt();
                      } else {
                        EasyLoading.showError(appLocalizations.no_data);
                      }
                    },
                    child: Text(
                      appLocalizations.btn_export_data,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title:
                                    Text(appLocalizations.popup_del_title_all),
                                content:
                                    Text(appLocalizations.popup_del_sub_all),
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
                                      onPressed: () {
                                        context
                                            .read<TempMasterBloc>()
                                            .add(ClearTempMasterEvent());

                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        appLocalizations.btn_delete,
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ));
                    },
                    child: Text(
                      appLocalizations.btn_clear_all,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.orange)),
                  ),
                  IconButton(
                      onPressed: () {
                        isFilter = !isFilter;
                        if (isFilter) {
                          itemList.sort((a, b) {
                            int? rssiA = int.tryParse(a.rssi ?? "0");
                            int? rssiB = int.tryParse(b.rssi ?? "0");
                            return rssiA!.compareTo(rssiB!);
                          });

                          // do something
                        } else {
                          itemList.sort((a, b) {
                            int? rssiA = int.tryParse(a.rssi ?? "0");
                            int? rssiB = int.tryParse(b.rssi ?? "0");
                            return rssiB!.compareTo(rssiA!);
                          });

                          // do something
                        }
                        setState(() {});
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          isFilter ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              FutureBuilder(
                  future: SDK_Function.setTagScannedListener((epc, dbm) async {
                if (itemList.isNotEmpty) {
                  if (itemList
                      .where((qry) => qry.rfid_tag!.trim() == epc.trim())
                      .isNotEmpty) {
                    context.read<TempMasterBloc>().add(UpdateTempMasterEvent(
                        TempMasterRfidData(
                            key_id: 0,
                            rfid_tag: epc.trim(),
                            status: "Found",
                            rssi: dbm.trim(),
                            updated_at: DateTime.now())));
                    await SDK_Function.playSound();
                  }
                }
              }), builder: (context, snapshot) {
                return itemList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: itemList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              startActionPane: ActionPane(
                                motion: BehindMotion(),
                                children: [
                                  SlidableAction(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    borderRadius: BorderRadius.circular(12),
                                    spacing: 1,
                                    onPressed: (BuildContext context) async {
                                      await showAddRfidDialog(
                                          context,
                                          itemList[index].key_id,
                                          itemList[index].rfid_tag!);

                                      Future.delayed(
                                          Duration(milliseconds: 500),
                                          () async {
                                        itemList =
                                            await appDb.getAllTempMaster();
                                        temp_itemList = itemList;
                                        setState(() {});
                                      });
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: appLocalizations.btn_edit,
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: BehindMotion(),
                                children: [
                                  SlidableAction(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    borderRadius: BorderRadius.circular(12),
                                    spacing: 1,
                                    onPressed: (BuildContext context) {
                                      context.read<TempMasterBloc>().add(
                                          DeleteTempMasterEvent(
                                              itemList[index].key_id));
                                      itemList.removeAt(index);
                                      // context
                                      //     .read<SearchRfidBloc>()
                                      //     .add(DeleteRfidEvent(itemModel[index].key_id!));

                                      setState(() {});
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: appLocalizations.btn_delete,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                child: Card(
                                  color: itemList[index].status == "Found"
                                      ? Colors.green
                                      : Colors.red,
                                  margin: EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${appLocalizations.txt_number_tag} : ${itemList[index].rfid_tag}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              itemList[index].rssi != null
                                                  ? 'Rssi: ${itemList[index].rssi} dBm'
                                                  : "Rssi: ${appLocalizations.txt_not_found}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            '${appLocalizations.txt_created} : ${DateFormat('dd-MM-yyyy HH:mm').format(itemList[index].created_at!)}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            itemList[index].updated_at != null
                                                ? Text(
                                                    '${appLocalizations.txt_updated} : ${DateFormat('dd-MM-yyyy HH:mm').format(itemList[index].updated_at!)}',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                                : SizedBox.fromSize(),
                                            Text(
                                                '${appLocalizations.txt_status} : ${itemList[index].status == "Found" ? appLocalizations.txt_found : appLocalizations.txt_not_found} ',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(appLocalizations.no_data),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }

  // สร้างฟังก์ชันที่แสดง AlertDialog สำหรับกรอก new Rfid และมีปุ่ม Save และ Close
  Future<void> showAddRfidDialog(
      BuildContext context, int key_id, String rfid) async {
    final Completer<void> completer = Completer<void>();
    TextEditingController rfidController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(appLocalizations.txt_edit_rfid)],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${appLocalizations.txt_curent_rfid}: $rfid"),
              TextField(
                autofocus: true,
                controller: rfidController,
                decoration: InputDecoration(
                  hintText: appLocalizations.txt_new_rfid,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green),
              ),
              child: Text(
                appLocalizations.btn_save,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (rfidController.text.isNotEmpty) {
                  if (itemList
                      .where(
                          (qry) => qry.rfid_tag == rfidController.text.trim())
                      .isNotEmpty) {
                    EasyLoading.showError(appLocalizations.txt_duplicate_edit);
                  } else {
                    context.read<TempMasterBloc>().add(EditTempMasterEvent(
                        TempMasterRfidData(
                            key_id: key_id,
                            rfid_tag:
                                rfidController.text.trim().toUpperCase())));
                    Navigator.of(context).pop();
                    completer.complete();
                  }

                  setState(() {});
                }

                // ปิด dialog เมื่อกด Save
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: Text(
                appLocalizations.btn_cancel,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // ปิด dialog เมื่อกด Close
                completer.complete();
              },
            ),
          ],
        );
      },
    );
    await completer.future;
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

        var pathFile = '$selectDirectory/fi_rfid_$formattedDate.txt';
        var file = File(pathFile);
        var sink = file.openWrite();
        sink.write('tag|Rssi|status|created|updated\n');
        for (var item in itemList) {
          sink.write(
              '${item.rfid_tag}|${item.rssi} dBm|${item.status}|${item.created_at}|${item.updated_at ?? "N/A"}\n');
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
