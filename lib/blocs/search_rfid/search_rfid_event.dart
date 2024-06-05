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
