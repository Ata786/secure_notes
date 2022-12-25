part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}
class PostChangeState extends PostState {
  bool check;
  PostChangeState(this.check);
}
