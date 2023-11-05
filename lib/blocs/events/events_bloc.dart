import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:personal_proyecto/screens/inicio.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsInitialState()) {
    loadEvents();
  }

  loadEvents(){
    validarCambioForm();
    estadoInicial();
  }

  estadoInicial(){
    on<InitialStateEvent>((event, emit) {
      emit(EventsInitialState());
    });
  }

  validarCambioForm(){
    on<ChangeStateMenu>((event, emit) {
      emit(EventsChangeState(event.states,event.menu));
    });
  }
  
}
