import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/app.dart';
import 'package:rfid/main.dart';
import 'package:rfid/modelResponse/DefaultResponse.dart';

import '../../database/database.dart';

part 'temp_master_event.dart';
part 'temp_master_state.dart';

class TempMasterBloc extends Bloc<TempMasterEvent, TempMasterState> {
  Dio dio = Dio();
  TempMasterBloc() : super(TempMasterInitial()) {
    on<TempMasterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.getAllTempMaster();
        if (result.isNotEmpty) {
          emit(state.copyWith(status: FetchStatus.success, data: result));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Data not found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
      // TODO: implement event handler
    });
    on<EditTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.editTempMaster(event.data);
        if (result) {
          emit(state.copyWith(
              status: FetchStatus.sendSuccess,
              dataDefaultResponse:
                  DefaultResponse(message: "Success", statusCode: result)));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Data not found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
      // TODO: implement event handler
    });

    on<DeleteTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.deleteTempMaster(event.key_id);
        if (result) {
          emit(state.copyWith(
              status: FetchStatus.saved,
              dataDefaultResponse:
                  DefaultResponse(message: "Success", statusCode: result)));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Data not found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
      // TODO: implement event handler
    });
    on<AddTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.insertOrUpdateTempMaster(event.model);
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
      // TODO: implement event handler
    });
    on<UpdateTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.updateTempMaster(event.model);
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
      // TODO: implement event handler
    });
    on<ClearTempMasterEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));

        var result = await appDb.clearAllTempMaster();
        print(result);
        if (result) {
          emit(state.copyWith(
              status: FetchStatus.deleteSuccess,
              dataDefaultResponse:
                  DefaultResponse(message: "Success", statusCode: result)));
        } else {
          emit(state.copyWith(
              status: FetchStatus.failed, message: "Data not found"));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
      // TODO: implement event handler
    });
  }
}
