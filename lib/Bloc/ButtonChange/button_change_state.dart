part of 'button_change_bloc.dart';

@immutable
abstract class ButtonChangeState {}

class ButtonChangeInitial extends ButtonChangeState {}

class ChangeItemState extends ButtonChangeState {
  int i;
  ChangeItemState(this.i);
}

