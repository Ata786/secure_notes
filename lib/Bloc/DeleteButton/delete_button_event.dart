part of 'delete_button_bloc.dart';

@immutable
abstract class DeleteButtonEvent {}

class DeleteButtonCheckEvent extends DeleteButtonEvent{

  int i;
  DeleteButtonCheckEvent(this.i);

}