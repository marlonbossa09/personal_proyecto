part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  final bool vistaLogin;
  const LoginState({this.vistaLogin = false});
}

class LoginInitialState extends LoginState {
  const LoginInitialState() : super(vistaLogin: false);
}

class LoginChangeVistaState extends LoginState {
  final bool login;
  const LoginChangeVistaState(this.login) : super(vistaLogin: login);
}
