import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:personal_proyecto/models/UserModel.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitialState()) {
    loadEvents();
  }

  loadEvents(){
    activateUser();
    initialState();
  }

  activateUser(){
    on<ActivateUserEvent>((event, emit) {
        emit(UserSetState(event.user));
    });
  }

  initialState(){
    on<InitialUserEvent>((event, emit) {
        emit(UserInitialState());
    });
  }
}
