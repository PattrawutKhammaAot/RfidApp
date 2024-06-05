part of 'search_rfid_bloc.dart';

class SearchRfidState extends Equatable {
  final SearchRfidModel? data;
  final FetchStatus status;
  final String message;
  const SearchRfidState(
      {this.data, this.status = FetchStatus.init, this.message = ''});

  SearchRfidState copyWith({
    SearchRfidModel? data,
    FetchStatus? status,
    String? message,
  }) {
    return SearchRfidState(
        data: data = data ?? this.data,
        status: status = status ?? this.status,
        message: message = message ?? this.message);
  }

  @override
  List<Object> get props => [status, message];
}

class SearchRfidInitial extends SearchRfidState {
  @override
  List<Object> get props => [];
}
