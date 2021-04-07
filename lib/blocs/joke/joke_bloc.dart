import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:joke_app/data/models/joke.dart';
import '../../data/repositories/jokes_repository.dart';

part 'joke_event.dart';
part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokesRepository jokeRepository;
  JokeBloc({@required this.jokeRepository})
      : super(JokeInitial());

  Joke joke;

  @override
  Stream<JokeState> mapEventToState(
    JokeEvent event,
  ) async* {
    if (event is GetJokeEvent) {
        yield JokeLoadingState();
        try {
          joke = await jokeRepository.getRandomJoke(event.filters);
          yield JokeLoadedState(joke: joke);
        } catch (err, st) {
          print(err);
          print(st);
          yield JokeLoadingError();
        }
      }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
