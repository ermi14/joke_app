part of 'joke_bloc.dart';

abstract class JokeState extends Equatable {
  const JokeState();

  @override
  List<Object> get props => [];
}

class JokeInitial extends JokeState {}

class JokeLoadingState extends JokeState {}

class JokeLoadedState extends JokeState {
  final Joke joke;

  JokeLoadedState({this.joke});

  @override
  List<Object> get props => [joke];
}

class JokeLoadingError extends JokeState {}
