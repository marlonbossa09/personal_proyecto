import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:personal_proyecto/models/EstudiantesModel.dart';

part 'usuarios_event.dart';
part 'usuarios_state.dart';

class UsuariosBloc extends Bloc<UsuariosEvent, UsuariosState> {
  UsuariosBloc() : super(UsuariosInitialState()) {
    loadEvents();
  }

  loadEvents(){
    activateUser();
    initialState();
  }

  activateUser(){
    on<ChangeDataUsuariosEvent>((event, emit) {
        emit(UsuariosSetState(event.user,event.chargin));
    });
  }

  initialState(){
    on<InitialUsuariosEvent>((event, emit) {
        emit(UsuariosInitialState());
    });
  }
}
