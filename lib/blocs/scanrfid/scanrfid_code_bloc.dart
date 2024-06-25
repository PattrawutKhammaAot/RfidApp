import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/scanrfid/models/ScanRfidCodeModel.dart';
import 'package:rfid/blocs/scanrfid/models/importRfidCodeModel.dart';
import 'package:rfid/blocs/scanrfid/models/rfidItemListToJsonModel.dart';
import 'package:rfid/blocs/scanrfid/models/total_scan_Model.dart';
import 'package:rfid/config/appConfig.dart';
import 'package:rfid/database/database.dart';
import 'package:rfid/main.dart';
import 'package:rfid/modelResponse/DefaultResponse.dart';

part 'scanrfid_code_event.dart';
part 'scanrfid_code_state.dart';

class ScanrfidCodeBloc extends Bloc<ScanrfidCodeEvent, ScanrfidCodeState> {
  Dio dio = Dio();
  ScanrfidCodeBloc() : super(ScanrfidCodeInitial()) {
    // dio.httpClientAdapter = IOHttpClientAdapter(
    //   onHttpClientCreate: (_) {
    //     // Don't trust any certificate just because their root cert is trusted.
    //     final HttpClient client =
    //         HttpClient(context: SecurityContext(withTrustedRoots: false));
    //     // You can test the intermediate / root cert here. We just ignore it.
    //     client.badCertificateCallback = (cert, host, port) => true;
    //     return client;
    //   },
    // );
    on<GetRfidItemListEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var responseData = await getRfidFetch();
        if (responseData.isNotEmpty) {
          emit(state.copyWith(status: FetchStatus.success, data: responseData));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "No data found"));
        }
      } catch (e, s) {
        print(e);
        print(s);
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<SendRfidCodeEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.sending));

        var responseData = await sendRfidFetch(event.rfidCode);
        if (responseData.statusCode!) {
          emit(state.copyWith(
            status: FetchStatus.sendSuccess,
            message: responseData.message,
          ));
        } else {
          emit(state.copyWith(
              status: FetchStatus.sendFailed, message: responseData.message));
        }
      } catch (e, s) {
        print(e);
        print(s);
        emit(state.copyWith(
            status: FetchStatus.sendFailed, message: e.toString()));
      }
    });
    on<GetTotoalScanEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var responseData = await getTotalScanFetching();
        if (responseData.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.success, totalScanModel: responseData));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: responseData.message));
        }
      } catch (e, s) {
        print(e);
        print(s);
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<ImportRfidCodeEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.importLoading));

        var responseData =
            await importRfidFetching(event.rfidItemListToJsonModel);
        if (responseData.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.importFinish, message: responseData.message));
        } else {
          emit(state.copyWith(
              status: FetchStatus.importFailed, message: responseData.message));
        }
      } catch (e, s) {
        print(e);
        print(s);
        emit(state.copyWith(
            status: FetchStatus.importFailed, message: e.toString()));
      }
    });
  }

  Future<List<Master_rfidData>> getRfidFetch() async {
    try {
      var result = await appDb.getMasterAll();
      // print("Test ${result}");
      // Response responese = await dio.get(
      //   ApiConfig.RFID_TAG_LIST,
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );

      // print(responese.data);
      List<Master_rfidData> post = result;
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> sendRfidFetch(ScanRfidCodeModel dto) async {
    try {
      var result = await appDb.scan_Rfid_Code(dto);

      DefaultResponse post =
          DefaultResponse(message: "Success", statusCode: result);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<TotalScanModel> getTotalScanFetching() async {
    try {
      var result = await appDb.totalMaster();
      var totalLoss = await appDb.totalFilter("Not Found");
      var totalFound = await appDb.totalFilter("Found");
      print("Total Master $result NotFound $totalLoss Found $totalFound");

      TotalScanModel post = TotalScanModel(
          totalMaster: result,
          totalLoss: totalLoss,
          totalFound: totalFound,
          statusCode: true);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> importRfidFetching(
      List<ImportRfidCodeModel> dto) async {
    try {
      var result = await appDb.importMasterWithTxt(dto);
      // List<Map<String, dynamic>> jsonData =
      //     dto.map((item) => item.toJson()).toList();
      // Response responese = await dio.post(
      //   ApiConfig.IMPORT_RFID_TAG,
      //   data: jsonData,
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );

      DefaultResponse post = DefaultResponse(statusCode: result, message: "");
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
