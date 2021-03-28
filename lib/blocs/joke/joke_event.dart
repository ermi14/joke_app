part of 'joke_bloc.dart';

abstract class JokeEvent extends Equatable {
  const JokeEvent();

  @override
  List<Object> get props => [];
}

class GetJokeEvent extends JokeEvent {
  final List<String> filters;

  GetJokeEvent({this.filters});

  @override
  List<Object> get props => [filters];
}
