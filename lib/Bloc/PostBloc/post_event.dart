part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class PostChangeEvent extends PostEvent{
  bool check;
  PostChangeEvent(this.check);
}
