part of 'check_box_bloc.dart';

@immutable
abstract class CheckBoxState {}

class CheckBoxInitial extends CheckBoxState {}

class CheckBoxStateFirst extends CheckBoxState{
  int i;
  CheckBoxStateFirst(this.i);
}
