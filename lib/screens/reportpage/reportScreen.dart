import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/scanrfid/models/total_scan_Model.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/config/appConstants.dart';
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
  List<DropdownMenuItem<String>> items = ["Master", "Loss", "Found"]
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<ScanrfidCodeBloc>(context).add(
      GetTotoalScanEvent(),
    );
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
                    'Master',
                    double.parse(totalScanModel.totalMaster.toString()),
                    Colors.blueGrey));
                chartData.add(ChartData(
                    'Loss',
                    double.parse(totalScanModel.totalLoss.toString()),
                    Colors.red));
                chartData.add(ChartData(
                    'Found',
                    double.parse(totalScanModel.totalFound.toString()),
                    Colors.green[300]));

                setState(() {});
              }
            }
            if (state.status == FetchStatus.failed) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.message);
            }
          })
        ],
        child: Scaffold(
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
            ),
            onPressed: () {},
            child: Text(
              "Import Data",
              style: TextStyle(color: whiteColor),
            ),
          ),
          body: Column(
            children: [
              // Expanded(
              //     child: ListView.builder(
              //   padding: EdgeInsets.all(15),
              //   itemCount: 10,
              //   itemBuilder: (context, index) {
              //     return Card(
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text("RFID Number :"),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // )),

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
                          radius: '100%',
                          explode: true,
                        ),
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
                    Text("Information"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[100],
                      child: Text("${totalScanModel.totalLoss}"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[200],
                      child: const Text('Heed not the rabble'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[300],
                      child: const Text('Sound of screams but the'),
                    ),
                  ],
                ),
              )

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
