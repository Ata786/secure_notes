part of 'button_change_bloc.dart';

@immutable
abstract class ButtonChangeEvent {}

class ChangeItemEvent extends ButtonChangeEvent{
  int i;
  ChangeItemEvent(this.i);
}

