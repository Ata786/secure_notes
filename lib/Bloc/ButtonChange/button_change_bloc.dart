import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'button_change_event.dart';
part 'button_change_state.dart';

class ButtonChangeBloc extends Bloc<ButtonChangeEvent, ButtonChangeState> {
  ButtonChangeBloc() : super(ButtonChangeInitial()) {

    on<ChangeItemEvent>((event, emit) {
      emit.call(ChangeItemState(event.i));
    });

  }
}
