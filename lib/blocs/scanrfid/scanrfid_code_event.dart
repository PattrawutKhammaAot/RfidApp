part of 'scanrfid_code_bloc.dart';

class ScanrfidCodeEvent extends Equatable {
  const ScanrfidCodeEvent();

  @override
  List<Object> get props => [];
}

class GetRfidItemListEvent extends ScanrfidCodeEvent {
  const GetRfidItemListEvent();
  @override
  List<Object> get props => [];
}

class ImportRfidCodeEvent extends ScanrfidCodeEvent {
  final List<ImportRfidCodeModel> rfidItemListToJsonModel;
  const ImportRfidCodeEvent(this.rfidItemListToJsonModel);
  @override
  List<Object> get props => [rfidItemListToJsonModel];
}

class SendRfidCodeEvent extends ScanrfidCodeEvent {
  final ScanRfidCodeModel rfidCode;
  const SendRfidCodeEvent(this.rfidCode);
  @override
  List<Object> get props => [rfidCode];
}

class GetTotoalScanEvent extends ScanrfidCodeEvent {
  const GetTotoalScanEvent();
  @override
  List<Object> get props => [];
}
