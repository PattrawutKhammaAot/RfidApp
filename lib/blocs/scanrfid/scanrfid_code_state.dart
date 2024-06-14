part of 'scanrfid_code_bloc.dart';

class ScanrfidCodeState extends Equatable {
  final List<Master_rfidData>? data;
  final FetchStatus status;
  final String message;
  final TotalScanModel? totalScanModel;

  const ScanrfidCodeState(
      {this.data,
      this.status = FetchStatus.init,
      this.message = '',
      this.totalScanModel});

  ScanrfidCodeState copyWith({
    List<Master_rfidData>? data,
    FetchStatus? status,
    String? message,
    TotalScanModel? totalScanModel,
  }) {
    return ScanrfidCodeState(
        // dataDocSum: dataDocSum = dataDocSum ?? this.dataDocSum,
        data: data = data ?? this.data,
        status: status = status ?? this.status,
        message: message = message ?? this.message,
        totalScanModel: totalScanModel = totalScanModel ?? this.totalScanModel);
  }

  @override
  List<Object> get props => [status, message];
}

class ScanrfidCodeInitial extends ScanrfidCodeState {
  @override
  List<Object> get props => [];
}
