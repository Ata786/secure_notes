part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpNameState extends SignUpState {
  String name;

  SignUpNameState(this.name);
}

class SignUpEmailState extends SignUpState {
  String email;

  SignUpEmailState(this.email);
}

class SignUpPasswordState extends SignUpState {
  String password;

  SignUpPasswordState(this.password);
}