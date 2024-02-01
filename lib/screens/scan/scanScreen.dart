import 'package:flutter/material.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ZincDataSource? zincDataSource;

  @override
  void initState() {
    // TODO: implement initState

    zincDataSource = ZincDataSource(process: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Page Title",
            style: TextStyle(color: whiteColor),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Scan",
                  hintText: "Hint Text",
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SfDataGrid(
                source: zincDataSource!,
                headerGridLinesVisibility: GridLinesVisibility.both,
                gridLinesVisibility: GridLinesVisibility.both,
                selectionMode: SelectionMode.multiple,
                allowPullToRefresh: true,
                allowColumnsResizing: true,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(
                    visible: true,
                    columnName: 'ID',
                    label: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'ID',
                        ),
                      ),
                    ),
                  ),
                  GridColumn(
                    visible: true,
                    columnName: 'batch',
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
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
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
                        border: Border.all(color: Colors.white, width: 1)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total: 0"),
                        Text("Total: 0"),
                        Text("Total: 0"),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}
