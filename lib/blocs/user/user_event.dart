part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class InitialUserEvent extends UserEvent {}

class ActivateUserEvent extends UserEvent {
  final User user;
  ActivateUserEvent(this.user);
}
