import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/search_rfid/models/search_rfid_model.dart';
import 'package:rfid/config/appConfig.dart';
import 'package:rfid/database/database.dart';
import 'package:rfid/main.dart';
import 'package:rfid/modelResponse/DefaultResponse.dart';

part 'search_rfid_event.dart';
part 'search_rfid_state.dart';

class SearchRfidBloc extends Bloc<SearchRfidEvent, SearchRfidState> {
  Dio dio = Dio();
  SearchRfidBloc() : super(SearchRfidInitial()) {
    on<SerachEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await searchRfidFetch(event.rfid);
        if (result.isNotEmpty) {
          print(" true");
          emit(state.copyWith(status: FetchStatus.saved, data: result));
        } else {
          print("false");
          emit(state.copyWith(
              status: FetchStatus.failed, message: "No data found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<DeleteRfidEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await deleteRfidFetch(event.key_id);
        if (result.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.deleteSuccess, dataDefaultResponse: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: result.message));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<DeleteAllEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await deleteAllData(event.key_id);
        if (result.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.deleteAllSuccess,
              dataDefaultResponse: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: result.message));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
  }

  Future<List<Tag_Running_RfidData>> searchRfidFetch(String tag_id) async {
    try {
      var result = await appDb.search_tag_rfid(tag_id);
      // Response responese = await dio.get(
      //   ApiConfig.SERACH_TAG_RFID + "?rfid=$tag_id",
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );

      List<Tag_Running_RfidData> post = result;
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> deleteRfidFetch(int key_id) async {
    try {
      print("Send ${key_id}");
      var result = await appDb.deleteRunningRfid(key_id);
      // print(ApiConfig.DELETE_SERACH_TAG_RFID);
      // Response responese = await dio.post(
      //   ApiConfig.DELETE_SERACH_TAG_RFID,
      //   data: {"key_id": key_id},
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );
      // print(responese.data);
      print(result);

      DefaultResponse post =
          DefaultResponse(statusCode: result, message: "Success");
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> deleteAllData(List<int> key_id) async {
    try {
      DefaultResponse post =
          DefaultResponse(statusCode: false, message: "No data found");
      if (key_id.isNotEmpty) {
        for (var i in key_id) {
          var result = await appDb.deleteRunningRfid(i);
          post = DefaultResponse(statusCode: result, message: "Success");
        }
      }

      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
