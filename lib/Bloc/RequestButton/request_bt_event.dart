part of 'request_bt_bloc.dart';

@immutable
abstract class RequestBtEvent {}

class RequestEvent extends RequestBtEvent{
  int i;
  RequestEvent(this.i);
}
