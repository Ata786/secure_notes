import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SignUpNameEvent>((event, emit) {
      emit.call(SignUpNameState(event.name));
    });

    on<SignUpEmailEvent>((event, emit) {
      emit.call(SignUpEmailState(event.email));
    });

    on<SignUpPasswordEvent>((event, emit) {
      emit.call(SignUpPasswordState(event.password));
    });


  }
}

