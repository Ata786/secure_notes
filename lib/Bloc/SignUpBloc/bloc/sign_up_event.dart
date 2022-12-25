part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpNameEvent extends SignUpEvent {
  String name;

  SignUpNameEvent(this.name);
}

class SignUpEmailEvent extends SignUpEvent {
  String email;

  SignUpEmailEvent(this.email);
}

class SignUpPasswordEvent extends SignUpEvent {
  String password;

  SignUpPasswordEvent(this.password);
}
