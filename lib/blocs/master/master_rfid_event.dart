part of 'master_rfid_bloc.dart';

class MasterRfidEvent extends Equatable {
  const MasterRfidEvent();

  @override
  List<Object> get props => [];
}

class DeleteMasterRfidEvent extends MasterRfidEvent {
  const DeleteMasterRfidEvent(this.key_id);
  final int key_id;

  @override
  List<Object> get props => [key_id];
}

class GetMasterRfidEvent extends MasterRfidEvent {
  const GetMasterRfidEvent();

  @override
  List<Object> get props => [];
}

class AddMasterEvent extends MasterRfidEvent {
  const AddMasterEvent(this.model);
  final ImportRfidCodeModel model;

  @override
  List<Object> get props => [model];
}

class SearchMasterEvent extends MasterRfidEvent {
  const SearchMasterEvent(this.search);
  final String search;

  @override
  List<Object> get props => [search];
}

class EditMasterEvent extends MasterRfidEvent {
  const EditMasterEvent(this.data);
  final Master_rfidData data;

  @override
  List<Object> get props => [data];
}
