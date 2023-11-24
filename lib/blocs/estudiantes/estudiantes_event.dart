part of 'estudiantes_bloc.dart';

@immutable
abstract class UserEvent {}

class InitialUserEvent extends UserEvent {}

class ActivateUserEvent extends UserEvent {
  final Estudiantes user;
  ActivateUserEvent(this.user);
}
