part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class InitialUserEvent extends UserEvent {}

class ActivateUserEvent extends UserEvent {
  final UsuarioGeneralModel user;
  ActivateUserEvent(this.user);
}
