import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/master/master_rfid_bloc.dart';
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
  List<Master_rfidData> itemList = [];
  List<Master_rfidData> temp_itemList = [];
  bool isScanning = false;

  @override
  void initState() {
    focusNode.requestFocus();
    BlocProvider.of<MasterRfidBloc>(context).add(
      GetMasterRfidEvent(),
    );
    Future.delayed(Duration(milliseconds: 500), () async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (e) async {
        if (e is KeyDownEvent) {
          await SDK_Function.scan(true);
          isScanning = true;
          setState(() {});
        } else if (e is KeyUpEvent) {
          await SDK_Function.scan(false);
          isScanning = false;
          setState(() {});
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<MasterRfidBloc, MasterRfidState>(
              listener: (context, state) async {
            if (state.status == FetchStatus.fetching) {}
            if (state.status == FetchStatus.saved) {
              setState(() {
                itemList = state.data!;
              });
            }
            if (state.status == FetchStatus.searchSuccess) {
              itemList = state.data!;

              setState(() {});
            }
            if (state.status == FetchStatus.importFinish) {
              temp_itemList = itemList;
              setState(() {});
              BlocProvider.of<MasterRfidBloc>(context).add(
                GetMasterRfidEvent(),
              );
            }
            if (state.status == FetchStatus.failed) {}
            if (state.status == FetchStatus.deleteSuccess) {
              EasyLoading.showSuccess("Delete Success");
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (searchController.text.length > 1) {
                          context.read<MasterRfidBloc>().add(
                              SearchMasterEvent(searchController.text.trim()));
                        } else if (searchController.text.length == 0) {
                          context
                              .read<MasterRfidBloc>()
                              .add(SearchMasterEvent(''));
                        }
                      },
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Search',
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      onEventScan(searchController.text.trim(), "0");
                      searchController.clear();
                      focusNode.requestFocus();
                    }
                  },
                ),
              ),
              FutureBuilder(
                  future: SDK_Function.setTagScannedListener((epc, dbm) async {
                await onEventScan(epc.trim(), dbm.trim());
                // _addTable.add(tempRfidItemList(
                //   rfid_tag: epc,
                //   rssi: dbm,
                //   status: "Found",
                // ));
                // setState(() {
                //   zincDataSource =
                //       ZincDataSource(process: _addTable);
                // });
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

                                      itemList = await appDb.getMasterAll();
                                      setState(() {});
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Edit',
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
                                      context.read<MasterRfidBloc>().add(
                                          DeleteMasterRfidEvent(
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
                                    label: 'Delete',
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
                                        Text(
                                          'RFID Tag : ${itemList[index].rfid_tag}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'Created : ${DateFormat('dd-MM-yyyy').format(itemList[index].created_at!)}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            itemList[index].updated_at != null
                                                ? Text(
                                                    'Updated : ${DateFormat('dd-MM-yyyy').format(itemList[index].updated_at!)}',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                                : SizedBox.fromSize(),
                                            Text(
                                                'Status : ${itemList[index].status ?? "Not Found"} ',
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
                        child: Text("No data"),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }

  Future onEventScan(String _controller, String rssi) async {
    try {
      if (_controller.isNotEmpty) {
        if (temp_itemList
            .where((element) => element.rfid_tag == _controller.trim())
            .isEmpty) {
          context
              .read<MasterRfidBloc>()
              .add(AddMasterEvent(ImportRfidCodeModel(rfidTag: _controller)));
        }
      }
    } catch (e, s) {
      print("$e$s");
    }

    setState(() {});
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
            children: [Text('Add New Rfid'), Text("Current Rfid: $rfid")],
          ),
          content: TextField(
            controller: rfidController,
            decoration: InputDecoration(hintText: "Enter new Rfid"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                context.read<MasterRfidBloc>().add(EditMasterEvent(
                    Master_rfidData(
                        key_id: key_id, rfid_tag: rfidController.text.trim())));

                setState(() {});
                Navigator.of(context).pop();
                completer.complete();
                // ปิด dialog เมื่อกด Save
              },
            ),
            TextButton(
              child: Text('Close'),
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
}
