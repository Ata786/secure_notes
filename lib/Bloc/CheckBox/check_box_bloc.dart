
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_box_event.dart';
part 'check_box_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc() : super(CheckBoxInitial()) {

    on<CheckBoxEvent>((event, emit) => null);

    on<CheckBoxEventFirst>((event, emit){
      emit.call(CheckBoxStateFirst(event.i));
    });

  }
}
