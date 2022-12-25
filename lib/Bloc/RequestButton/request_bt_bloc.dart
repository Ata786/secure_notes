import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_bt_event.dart';
part 'request_bt_state.dart';

class RequestBtBloc extends Bloc<RequestBtEvent, RequestBtState> {
  RequestBtBloc() : super(RequestBtInitial()) {
    on<RequestEvent>((event, emit) {
      emit.call(RequestState(event.i));
    });
  }
}
