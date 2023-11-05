part of 'events_bloc.dart';

@immutable
abstract class EventsEvent {}

class InitialStateEvent extends EventsEvent{
}


class ChangeStateMenu extends EventsEvent{
  final List<bool> states;
  final Map menu;
  ChangeStateMenu(this.states,this.menu);
}