part of 'events_bloc.dart';

@immutable
abstract class EventsState {
  final List<bool> state;
  final Map menu;
  const EventsState({required this.state,required this.menu});
}

class EventsInitialState extends EventsState {
  EventsInitialState() : super(state:[false,false,false,false,false,false,false],menu: {'route':Inicio()});
}

class EventsChangeState extends EventsState {
  final List<bool> state_;
  final Map menu_;
  const EventsChangeState(this.state_,this.menu_) : super(state: state_,menu: menu_);
}
