import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_empty_event.dart';
part 'check_empty_state.dart';

class CheckEmptyBloc extends Bloc<CheckEmptyEvent, CheckEmptyState> {
  CheckEmptyBloc() : super(CheckEmptyInitial()) {
    on<CheckEmtpyEventEnable>((event, emit) {
      emit.call(CheckEmptyStateEnable(event.type));
    });
  }
}
