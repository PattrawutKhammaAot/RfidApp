part of 'master_rfid_bloc.dart';

class MasterRfidState extends Equatable {
  final List<Master_rfidData>? data;
  final FetchStatus status;
  final DefaultResponse? dataDefaultResponse;
  final String message;
  const MasterRfidState(
      {this.data,
      this.status = FetchStatus.init,
      this.message = '',
      this.dataDefaultResponse});

  MasterRfidState copyWith(
      {List<Master_rfidData>? data,
      FetchStatus? status,
      String? message,
      DefaultResponse? dataDefaultResponse}) {
    return MasterRfidState(
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

class MasterRfidInitial extends MasterRfidState {
  @override
  List<Object> get props => [];
}
