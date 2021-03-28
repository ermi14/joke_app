import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:joke_app/data/data_providers/joke_api.dart';
import 'package:joke_app/data/models/joke.dart';

class JokesRepository {
  final JokeApi jokeApi;

  JokesRepository({@required this.jokeApi});

  Future<Joke> getRandomJoke(List<String> filters) async {
    final JokeApi jokeApi = JokeApi();

    final response = await jokeApi.getJoke(filters);

    var jsonResponse = convert.jsonDecode(response.body);

    final Joke joke = Joke.fromJson(jsonResponse);

    return joke;
  }
}
