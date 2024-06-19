part of 'temp_master_bloc.dart';

class TempMasterState extends Equatable {
  final List<TempMasterRfidData>? data;
  final FetchStatus status;
  final DefaultResponse? dataDefaultResponse;
  final String message;

  const TempMasterState(
      {this.data,
      this.status = FetchStatus.init,
      this.message = '',
      this.dataDefaultResponse});

  TempMasterState copyWith(
      {List<TempMasterRfidData>? data,
      FetchStatus? status,
      String? message,
      DefaultResponse? dataDefaultResponse}) {
    return TempMasterState(
        data: data = data ?? this.data,
        status: status = status ?? this.status,
        message: message = message ?? this.message,
        dataDefaultResponse: dataDefaultResponse =
            dataDefaultResponse ?? this.dataDefaultResponse);
  }

  @override
  List<Object> get props => [
        status,
        message,
      ];
}

class TempMasterInitial extends TempMasterState {
  @override
  List<Object> get props => [];
}
