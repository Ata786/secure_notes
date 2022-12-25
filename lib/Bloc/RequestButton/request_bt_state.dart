part of 'request_bt_bloc.dart';

@immutable
abstract class RequestBtState {}

class RequestBtInitial extends RequestBtState {}

class RequestState extends RequestBtState {
  int i;
  RequestState(this.i);
}
