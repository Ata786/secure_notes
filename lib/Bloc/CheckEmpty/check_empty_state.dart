part of 'check_empty_bloc.dart';

@immutable
abstract class CheckEmptyState {}

class CheckEmptyInitial extends CheckEmptyState {}

class CheckEmptyStateEnable extends CheckEmptyState {
  bool type;
  CheckEmptyStateEnable(this.type);
}
