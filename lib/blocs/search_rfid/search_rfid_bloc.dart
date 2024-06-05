import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/app.dart';
import 'package:rfid/blocs/search_rfid/models/search_rfid_model.dart';
import 'package:rfid/config/appConfig.dart';

part 'search_rfid_event.dart';
part 'search_rfid_state.dart';

class SearchRfidBloc extends Bloc<SearchRfidEvent, SearchRfidState> {
  Dio dio = Dio();
  SearchRfidBloc() : super(SearchRfidInitial()) {
    on<SerachEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FetchStatus.fetching));
        var result = await searchRfidFetch(event.rfid);
        if (result.statusCode!) {
          print(" true");
          emit(state.copyWith(status: FetchStatus.saved, data: result));
        } else {
          print("false");
          emit(state.copyWith(
              status: FetchStatus.failed, message: result.message));
        }
      } catch (e, s) {
        print("$e$s");
        emit(state.copyWith(status: FetchStatus.failed, message: e.toString()));
      }
    });
  }

  Future<SearchRfidModel> searchRfidFetch(String tag_id) async {
    try {
      Response responese = await dio.get(
        ApiConfig.SERACH_TAG_RFID + "?rfid=$tag_id",
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      SearchRfidModel post = SearchRfidModel.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
