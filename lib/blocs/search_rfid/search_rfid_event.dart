part of 'search_rfid_bloc.dart';

class SearchRfidEvent extends Equatable {
  const SearchRfidEvent();

  @override
  List<Object> get props => [];
}

class SerachEvent extends SearchRfidEvent {
  const SerachEvent(this.rfid);
  final String rfid;

  @override
  List<Object> get props => [rfid];
}

class DeleteRfidEvent extends SearchRfidEvent {
  const DeleteRfidEvent(this.key_id);
  final int key_id;

  @override
  List<Object> get props => [key_id];
}

class DeleteAllEvent extends SearchRfidEvent {
  const DeleteAllEvent(this.key_id);
  final List<int> key_id;

  @override
  List<Object> get props => [key_id];
}
