import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/scanrfid/models/ScanRfidCodeModel.dart';
import 'package:rfid/blocs/scanrfid/models/rfidItemListToJsonModel.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/config/appConfig.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.onChange, this.receiveValue});
  final ValueChanged<List<tempRfidItemList>>? onChange;
  final List<tempRfidItemList>? receiveValue;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ZincDataSource? zincDataSource;
  RfidItemList itemList = RfidItemList();
  TextEditingController _controller = TextEditingController();
  List<tempRfidItemList> _addTable = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ScanrfidCodeBloc>(context).add(
      GetRfidItemListEvent(),
    );
    zincDataSource = ZincDataSource(process: []);

    // if (widget.receiveValue != null) {
    //   _addTable = widget.receiveValue!;
    //   zincDataSource = ZincDataSource(process: _addTable);
    // }

    super.initState();
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
              });
            }
          }
          if (state.status == FetchStatus.failed) {
            focusNode.requestFocus();
          }
        })
      ],
      child: Scaffold(
          body: itemList.itemListRfid != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (RawKeyEvent event) async {
                          // if (event is RawKeyDownEvent &&
                          //     event.logicalKey == LogicalKeyboardKey.enter) {
                          //   onEventScan();
                          //   await Future.delayed(Duration(milliseconds: 200));
                          //   _controller.clear();
                          //   await Future.delayed(Duration(milliseconds: 200));
                          //   focusNode.requestFocus();
                          //   // Execute your desired actions here
                          // } else if (event is RawKeyDownEvent) {
                          //   focusNode.requestFocus();
                          // }
                        },
                        child: TextFormField(
                          controller: _controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Scan",
                            hintText: "Hint Text",
                          ),
                          onFieldSubmitted: (value) async {
                            onEventScan();
                            await Future.delayed(Duration(milliseconds: 500));
                            _controller.clear();
                            await Future.delayed(Duration(milliseconds: 500));
                            focusNode.requestFocus();
                          },
                        ),
                      ),
                    ),
                    zincDataSource != null
                        ? Expanded(
                            flex: 2,
                            child: SfDataGrid(
                              source: zincDataSource!,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              gridLinesVisibility: GridLinesVisibility.both,
                              selectionMode: SelectionMode.multiple,
                              allowPullToRefresh: true,
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
                                        'RFID Tag',
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  visible: true,
                                  columnName: 'status',
                                  label: Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        'Status',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.fromSize(),
                    SizedBox(
                      height: 15,
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
                                      Text("Total: ${_addTable.length}"),
                                      Text(
                                          "Found: ${_addTable.where((element) => element.status == "Found").toList().length}"),
                                      Text(
                                          "Loss: ${_addTable.where((element) => element.status != "Found").toList().length}"),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : SizedBox.fromSize(),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator())),
    );
  }

  Future onEventScan() async {
    if (_controller.text.isNotEmpty) {
      var result = itemList.itemListRfid!
          .where((element) =>
              element.rfidNumber?.toUpperCase() ==
              _controller.text.toUpperCase())
          .toList();
      if (result.isNotEmpty) {
        if (_addTable
            .where((element) => element.rfid_tag == _controller.text)
            .toList()
            .isEmpty) {
          _addTable.add(tempRfidItemList(
            rfid_tag: _controller.text,
            status: "Found",
          ));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller.text,
                statusRunning: "Found",
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
        } else if (_addTable
            .where((element) =>
                element.rfid_tag == _controller.text &&
                element.status == "Not Found")
            .toList()
            .isNotEmpty) {
          _addTable
              .removeWhere((element) => element.rfid_tag == _controller.text);
          _addTable.add(tempRfidItemList(
            rfid_tag: _controller.text,
            status: "Found",
          ));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller.text,
                statusRunning: "Found",
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
        }
      } else {
        if (_addTable
            .where((element) => element.rfid_tag == _controller.text)
            .toList()
            .isEmpty) {
          _addTable.add(tempRfidItemList(
            rfid_tag: _controller.text,
            status: "Not Found",
          ));
          BlocProvider.of<ScanrfidCodeBloc>(context).add(
            SendRfidCodeEvent(ScanRfidCodeModel(
                rfidNumber: _controller.text,
                statusRunning: "Not Found",
                updateDate: DateTime.now())),
          );
          widget.onChange!(_addTable);
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
}
