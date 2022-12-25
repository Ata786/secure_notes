import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'delete_button_event.dart';
part 'delete_button_state.dart';

class DeleteButtonBloc extends Bloc<DeleteButtonEvent, DeleteButtonState> {
  DeleteButtonBloc() : super(DeleteButtonInitial()) {
    on<DeleteButtonCheckEvent>((event, emit) {
      emit.call(DeleteButtonCheckState(event.i));
    });
  }
}
