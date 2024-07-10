import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/scanrfid/models/importRfidCodeModel.dart';
import 'package:rfid/blocs/scanrfid/models/total_scan_Model.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/config/appData.dart';
import 'package:rfid/main.dart';
import 'package:rfid/screens/reportpage/model/import_txt.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.receiveValue});
  final List<tempRfidItemList>? receiveValue;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TotalScanModel totalScanModel = TotalScanModel();
  final List<ChartData> chartData = [];

  List<ImportRfidCodeModel> _itemImport = [];
  bool hasInvalidHeader = false;
  List<DropdownMenuItem<String>> items = ["Master", "Loss", "Found"]
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  void initState() {
    appDb.deleteTagRunningDuplicate().then((value) {
      BlocProvider.of<ScanrfidCodeBloc>(context).add(
        GetTotoalScanEvent(),
      );
    });

    AppData.setPopupInfo("page_report");
    // TODO: implement initState
    super.initState();
  }

  Future<void> _importCSV() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      final String csvPath = result.files.single.path!;

      final String csvString = await File(csvPath).readAsString(encoding: utf8);

      final List<List<dynamic>> csvData = CsvToListConverter().convert(
          csvString.toString().trim(),
          fieldDelimiter: '*|*',
          eol: '\n');

      csvData.forEach((row) {
        row.forEach((col) {
          final columData = col.toString().trim();
          if (columData.isNotEmpty) {
            ImportRfidCodeModel importModel = ImportRfidCodeModel(
              rfidTag: columData.replaceAll("|", ""),
              createDate: DateTime.now(),
            );

            _itemImport.add(importModel);
          }
        });
      });
      setState(() {});

      BlocProvider.of<ScanrfidCodeBloc>(context).add(
        ImportRfidCodeEvent(_itemImport),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ScanrfidCodeBloc, ScanrfidCodeState>(
              listener: (context, state) async {
            if (state.status == FetchStatus.fetching) {
              EasyLoading.show(status: 'loading...');
            }
            if (state.status == FetchStatus.success) {
              EasyLoading.dismiss();
              if (state.totalScanModel != null) {
                totalScanModel = state.totalScanModel!;

                chartData.add(ChartData(
                    appLocalizations.txt_master,
                    double.parse(totalScanModel.totalMaster.toString()),
                    blueColor_master));
                chartData.add(ChartData(
                    appLocalizations.txt_not_found,
                    double.parse(totalScanModel.totalLoss.toString()),
                    pinkPaletteColor_not_found));
                chartData.add(ChartData(
                    appLocalizations.txt_found,
                    double.parse(totalScanModel.totalFound.toString()),
                    pinkColor_found));

                chartData.add(ChartData(
                    appLocalizations.txt_not_scan,
                    double.parse((totalScanModel.totalMaster! -
                            totalScanModel.totalFound!)
                        .toString()),
                    pinkPaletteColor1_not_scan));

                setState(() {});
              }
            }
            if (state.status == FetchStatus.failed) {
              EasyLoading.dismiss();
              EasyLoading.showError("Error");
            }
            if (state.status == FetchStatus.importLoading) {
              EasyLoading.show(status: 'loading...');
            }
            if (state.status == FetchStatus.importFinish) {
              EasyLoading.dismiss();
              chartData.clear();
              _itemImport.clear();

              BlocProvider.of<ScanrfidCodeBloc>(context).add(
                GetTotoalScanEvent(),
              );
            }
            if (state.status == FetchStatus.failed) {
              EasyLoading.showError("error failed");
            }
          })
        ],
        child: Scaffold(
          floatingActionButton: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(blueColor_master),
            ),
            onPressed: () async {
              _importCSV();
            },
            child: Text(
              appLocalizations.btn_import_data,
              style: TextStyle(color: whiteColor),
            ),
          ),
          body: Column(
            children: [
              chartData.isNotEmpty
                  ? SfCircularChart(
                      title: ChartTitle(text: ''),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <PieSeries<ChartData, String>>[
                        PieSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y.toInt(),
                            pointColorMapper: (ChartData data, _) => data.color,
                            radius: '100%',
                            explode: true,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: false)),
                      ],
                    )
                  : CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(
                      width: 10,
                    ),
                    Text(appLocalizations.txt_information),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              totalScanModel.totalMaster != null
                  ? Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(10),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                  color: whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: CircularPercentIndicator(
                                radius: 45.0,
                                lineWidth: 8.0,
                                percent: 1.0,
                                center: new Text(
                                  "${appLocalizations.txt_master} \n ${totalScanModel.totalMaster} EA",
                                  textAlign: TextAlign.center,
                                ),
                                progressColor: blueColor_master,
                              )),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      1.0,
                                      1.0,
                                    ),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                color: whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: CircularPercentIndicator(
                              radius: 45.0,
                              lineWidth: 8.0,
                              percent: totalScanModel.totalMaster != 0 &&
                                      totalScanModel.totalFound != 0 &&
                                      totalScanModel.totalFound! <
                                          totalScanModel.totalMaster!
                                  ? totalScanModel.totalFound! /
                                      totalScanModel.totalMaster!
                                  : 1,
                              center: new Text(
                                "${appLocalizations.txt_found}  \n ${totalScanModel.totalFound != 0 && totalScanModel.totalMaster != 0 ? ((totalScanModel.totalFound! / totalScanModel.totalMaster!) * 100).toInt() : ""}% \n ${totalScanModel.totalFound} EA",
                                textAlign: TextAlign.center,
                              ),
                              progressColor: pinkColor_found,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      1.0,
                                      1.0,
                                    ),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                color: whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: CircularPercentIndicator(
                              radius: 45.0,
                              lineWidth: 8.0,
                              percent: totalScanModel.totalMaster != 0 &&
                                      totalScanModel.totalFound != 0
                                  ? (totalScanModel.totalMaster! -
                                          totalScanModel.totalFound!) /
                                      totalScanModel.totalMaster!
                                  : 1,
                              center: new Text(
                                "${appLocalizations.txt_not_scan}  \n ${totalScanModel.totalMaster != 0 && totalScanModel.totalFound != 0 ? (((totalScanModel.totalMaster! - totalScanModel.totalFound!) / totalScanModel.totalMaster!) * 100).toInt() : ""}% \n ${totalScanModel.totalMaster != 0 ? (totalScanModel.totalMaster! - totalScanModel.totalFound!) : "0"} EA",
                                textAlign: TextAlign.center,
                              ),
                              progressColor: pinkPaletteColor1_not_scan,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      1.0,
                                      1.0,
                                    ),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                color: whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: CircularPercentIndicator(
                              radius: 45.0,
                              lineWidth: 8.0,
                              percent: totalScanModel.totalLoss != null
                                  ? totalScanModel.totalLoss! >
                                          totalScanModel.totalMaster!
                                      ? 1.0
                                      : totalScanModel.totalLoss! /
                                          totalScanModel.totalMaster!
                                  : 0.0,
                              center: totalScanModel.totalLoss! >
                                      totalScanModel.totalMaster!
                                  ? Text(
                                      "${appLocalizations.txt_not_found} \n ${totalScanModel.totalLoss!} EA",
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "${appLocalizations.txt_not_found} \n ${totalScanModel.totalLoss != 0 && totalScanModel.totalMaster != 0 ? ((totalScanModel.totalLoss! / totalScanModel.totalMaster!) * 100).toInt() : "No data"}% \n ${totalScanModel.totalLoss} EA",
                                      textAlign: TextAlign.center,
                                    ),
                              progressColor: pinkPaletteColor_not_found,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator()

              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     //Initialize the spark charts widget
              //     child: SfSparkLineChart.custom(
              //       //Enable the trackball
              //       trackball: SparkChartTrackball(
              //           activationMode: SparkChartActivationMode.tap),
              //       //Enable marker
              //       marker: SparkChartMarker(
              //           displayMode: SparkChartMarkerDisplayMode.all),
              //       //Enable data label
              //       labelDisplayMode: SparkChartLabelDisplayMode.all,
              //       xValueMapper: (int index) => data[index].year,
              //       yValueMapper: (int index) => data[index].sales,
              //       dataCount: 5,
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
