import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/search_rfid/models/search_rfid_model.dart';
import 'package:rfid/database/database.dart';
import 'package:rfid/main.dart';
import 'package:rfid/modelResponse/DefaultResponse.dart';

import '../../config/appConfig.dart';
import '../scanrfid/models/importRfidCodeModel.dart';

part 'master_rfid_event.dart';
part 'master_rfid_state.dart';

class MasterRfidBloc extends Bloc<MasterRfidEvent, MasterRfidState> {
  Dio dio = Dio();
  MasterRfidBloc() : super(MasterRfidInitial()) {
    on<MasterRfidEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DeleteMasterRfidEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await deleteMasterRfidFetch(event.key_id);
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
    on<GetMasterRfidEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await getMasterAll();
        if (result.isNotEmpty) {
          emit(state.copyWith(status: FetchStatus.saved, data: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Data not found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<AddMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await AddMaster(event.model);
        if (result.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.importFinish, dataDefaultResponse: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: result.message));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<EditMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await EditMaster(event.data);
        print(result.statusCode);
        if (result.statusCode!) {
          emit(state.copyWith(
              status: FetchStatus.saved, dataDefaultResponse: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: result.message));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
    on<SearchMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await searchMaster(event.search);
        if (result.isNotEmpty) {
          emit(state.copyWith(status: FetchStatus.searchSuccess, data: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Tag invalid data"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
  }
  Future<DefaultResponse> EditMaster(Master_rfidData model) async {
    try {
      var result = await appDb.editMaster(model);
      // print("Test ${result}");
      // Response responese = await dio.get(
      //   ApiConfig.RFID_TAG_LIST,
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );

      // print(responese.data);
      DefaultResponse post =
          DefaultResponse(statusCode: result, message: "Success");
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<DefaultResponse> AddMaster(ImportRfidCodeModel model) async {
    try {
      var result = await appDb.scanImportMaster(model);
      // print("Test ${result}");
      // Response responese = await dio.get(
      //   ApiConfig.RFID_TAG_LIST,
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );

      // print(responese.data);
      DefaultResponse post =
          DefaultResponse(statusCode: result, message: "Success");
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<List<Master_rfidData>> getMasterAll() async {
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

  Future<List<Master_rfidData>> searchMaster(String s) async {
    try {
      var result = await appDb.serach_master(s);
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

  Future<DefaultResponse> deleteMasterRfidFetch(int key_id) async {
    try {
      var result = await appDb.deleteMaster(key_id);
      // print(ApiConfig.DELETE_SERACH_TAG_RFID);
      // Response responese = await dio.post(
      //   ApiConfig.DELETE_MASTER_TAG_RFID,
      //   data: {"key_id": key_id},
      //   options: Options(
      //       headers: ApiConfig.HEADER(),
      //       sendTimeout: Duration(seconds: 60),
      //       receiveTimeout: Duration(seconds: 60)),
      // );
      // print(responese.data);

      DefaultResponse post =
          DefaultResponse(statusCode: result, message: "Success");
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
