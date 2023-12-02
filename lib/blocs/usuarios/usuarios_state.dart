part of 'usuarios_bloc.dart';

@immutable
abstract class UsuariosState {
  final bool existUser;
  final List<UsuarioGeneralModel>? usuarios;
  final bool chargin;

  const UsuariosState({
    this.existUser = false,
    this.usuarios,
    this.chargin = false
  });
}

class UsuariosInitialState extends UsuariosState {
 UsuariosInitialState() : super(existUser: false, usuarios: null,chargin: false);
}

class UsuariosSetState extends UsuariosState {
  final List<UsuarioGeneralModel> usuarios;
  final bool chargin_;
  const UsuariosSetState(this.usuarios,this.chargin_) : super(existUser: true, usuarios: usuarios,chargin: chargin_);
}
