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
        if (responseData.statusCode ?? false) {
          emit(state.copyWith(status: FetchStatus.success, data: responseData));
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
    on<SendRfidCodeEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.sending));

        var responseData = await sendRfidFetch(event.rfidCode);
        if (responseData.statusCode ?? false) {
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
        if (responseData.statusCode ?? false) {
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
  }

  Future<RfidItemList> getRfidFetch() async {
    try {
      Response responese = await dio.get(
        ApiConfig.RFID_TAG_LIST,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      print(responese.data);
      RfidItemList post = RfidItemList.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> sendRfidFetch(ScanRfidCodeModel dto) async {
    try {
      Response responese = await dio.post(
        ApiConfig.SCAN_RFID_CODE,
        data: dto.toJson(),
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      DefaultResponse post = DefaultResponse.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<TotalScanModel> getTotalScanFetching() async {
    try {
      Response responese = await dio.get(
        ApiConfig.GET_TOTAL_SCAN,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      print(responese.data);
      TotalScanModel post = TotalScanModel.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
