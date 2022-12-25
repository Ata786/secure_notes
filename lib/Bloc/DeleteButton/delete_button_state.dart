part of 'delete_button_bloc.dart';

@immutable
abstract class DeleteButtonState {}

class DeleteButtonInitial extends DeleteButtonState {}

class DeleteButtonCheckState extends DeleteButtonState {
  int i;
  DeleteButtonCheckState(this.i);
}
