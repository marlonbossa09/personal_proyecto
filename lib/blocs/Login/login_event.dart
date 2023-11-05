part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class ChangeFormEvent extends LoginEvent {
  final bool estado;
  ChangeFormEvent(this.estado);
}
