part of 'temp_master_bloc.dart';

class TempMasterEvent extends Equatable {
  const TempMasterEvent();

  @override
  List<Object> get props => [];
}

class UpdateTempMasterEvent extends TempMasterEvent {
  const UpdateTempMasterEvent(this.model);
  final TempMasterRfidData model;

  @override
  List<Object> get props => [model];
}

class AddTempMasterEvent extends TempMasterEvent {
  const AddTempMasterEvent(this.model);
  final TempMasterRfidData model;

  @override
  List<Object> get props => [model];
}

class DeleteTempMasterEvent extends TempMasterEvent {
  const DeleteTempMasterEvent(this.key_id);
  final int key_id;

  @override
  List<Object> get props => [key_id];
}

class GetTempMasterEvent extends TempMasterEvent {
  const GetTempMasterEvent();

  @override
  List<Object> get props => [];
}

class EditTempMasterEvent extends TempMasterEvent {
  const EditTempMasterEvent(this.data);
  final TempMasterRfidData data;

  @override
  List<Object> get props => [data];
}

class ClearTempMasterEvent extends TempMasterEvent {
  const ClearTempMasterEvent();

  @override
  List<Object> get props => [];
}
