import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  LoginBloc() : super(LoginInitialState()) {
    loadEvents();
  }

  loadEvents(){
    validarCambioForm();
  }

  validarCambioForm(){
    on<ChangeFormEvent>((event, emit) {
      emit(LoginChangeVistaState(event.estado));
    });
  }

}
