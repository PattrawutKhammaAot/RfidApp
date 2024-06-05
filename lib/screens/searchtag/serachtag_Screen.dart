import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/search_rfid/models/search_rfid_model.dart';
import 'package:rfid/blocs/search_rfid/search_rfid_bloc.dart';

class SearchTagsScreen extends StatefulWidget {
  const SearchTagsScreen({super.key});

  @override
  State<SearchTagsScreen> createState() => _SearchTagsScreenState();
}

class _SearchTagsScreenState extends State<SearchTagsScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'One';
  bool isFilter = false;
  String isFilter_status = "Default";
  List<RfidData> itemModel = [];
  List<RfidData> temp_itemModel = [];
  @override
  void initState() {
    BlocProvider.of<SearchRfidBloc>(context).add(
      SerachEvent(''),
    );
    focusNode.requestFocus();
    // TODO: implement initState
    super.initState();
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

        var pathFile = '$selectDirectory/rfid_$formattedDate.txt';
        var file = File(pathFile);
        var sink = file.openWrite();
        sink.write('tag|Rssi|status\n');
        for (var item in itemModel) {
          sink.write('${item.tagId}|-${item.rssi} dBm|${item.status}\n');
        }

        await sink.close();
        EasyLoading.showSuccess("Export Data Success");
        print(pathFile);
      } else {
        openAppSettings();
      }
      print("object");
    } catch (e, s) {
      print("$e$s");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SearchRfidBloc, SearchRfidState>(
            listener: (context, state) async {
          if (state.status == FetchStatus.fetching) {}
          if (state.status == FetchStatus.saved) {
            itemModel = state.data!.data!;
            temp_itemModel = state.data!.data!;

            setState(() {});
          }
        })
      ],
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: searchController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      if (value.length > 1) {
                        context.read<SearchRfidBloc>().add(SerachEvent(value));
                      } else if (value.length == 0) {
                        context.read<SearchRfidBloc>().add(SerachEvent(''));
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueAccent)),
                        onPressed: () async {
                          if (itemModel.length > 0) {
                            await exportDataToTxt();
                          } else {
                            EasyLoading.showError("No Data");
                          }
                        },
                        child: const Text(
                          "Export Data",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                isFilter_status == "Found"
                                    ? Colors.green
                                    : isFilter_status == "Not Found"
                                        ? Colors.redAccent
                                        : Colors.blue)),
                        onPressed: () {
                          if (isFilter_status == "Default") {
                            itemModel = temp_itemModel
                                .where((element) => element.status == "Found")
                                .toList();
                            isFilter_status = "Found";
                          } else if (isFilter_status == "Found") {
                            itemModel = temp_itemModel
                                .where(
                                    (element) => element.status == "Not Found")
                                .toList();
                            isFilter_status = "Not Found";
                          } else if (isFilter_status == "Not Found") {
                            context.read<SearchRfidBloc>().add(SerachEvent(''));
                            isFilter_status = "Default";
                          }

                          setState(() {});
                        },
                        child: Text(
                          "Status: ${isFilter_status == "Default" ? "Select" : isFilter_status == "Not Found" ? "Not found" : "Found"}",
                          style: TextStyle(color: Colors.white),
                        )),
                    IconButton(
                        onPressed: () {
                          isFilter = !isFilter;
                          if (isFilter) {
                            itemModel
                                .sort((a, b) => a.rssi!.compareTo(b.rssi!));

                            // do somethings
                          } else {
                            itemModel
                                .sort((a, b) => b.rssi!.compareTo(a.rssi!));

                            // do somethings
                          }
                          setState(() {});
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            isFilter
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
                itemModel.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: itemModel.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: itemModel[index].status == "Found"
                                  ? Colors.green
                                  : Colors.redAccent,
                              margin: EdgeInsets.all(4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RFID Tag : ${itemModel[index].tagId}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Rssi : -${itemModel[index].rssi} dBm',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(
                                            'Status : ${itemModel[index].status}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Data"),
                      )
              ],
            )),
      ),
    );
  }
}
