part of 'check_empty_bloc.dart';

@immutable
abstract class CheckEmptyEvent {}

class CheckEmtpyEventEnable extends CheckEmptyEvent{
  bool type;
  CheckEmtpyEventEnable(this.type);

}
