part of 'usuarios_bloc.dart';

@immutable
abstract class UsuariosEvent {}

class InitialUsuariosEvent extends UsuariosEvent {}

class ChangeDataUsuariosEvent extends UsuariosEvent {
  final List<UsuarioGeneralModel> user;
  final bool chargin;
  ChangeDataUsuariosEvent(this.user,this.chargin);
}
