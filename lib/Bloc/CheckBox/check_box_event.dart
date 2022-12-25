part of 'check_box_bloc.dart';

@immutable
abstract class CheckBoxEvent {}

class CheckBoxEventFirst extends CheckBoxEvent{
  int i;
  CheckBoxEventFirst(this.i);
}
