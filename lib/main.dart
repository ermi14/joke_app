import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/blocs/authentication/auth_bloc.dart';
import 'package:joke_app/blocs/bloc_observer.dart';
import 'package:joke_app/blocs/joke/joke_bloc.dart';
import 'package:hive/hive.dart';
import 'package:joke_app/data/data_providers/joke_api.dart';
import 'package:joke_app/data/models/saved_joke.dart';
import 'package:joke_app/data/repositories/jokes_repository.dart';
import 'package:joke_app/data/repositories/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joke_app/presentation/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'presentation/pages/login_page.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(SavedJokeAdapter());
  await Hive.openBox<SavedJoke>('jokes');
  
  final UserRepository userRepository = UserRepository();
  runApp(MyApp(
    userRepository: userRepository,
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  const MyApp({UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    final JokeApi jokeApi = JokeApi();
    final JokesRepository jokesRepository = JokesRepository(jokeApi: jokeApi);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => AuthBloc(
                    userRepository: _userRepository,
                  )..add(AuthStarted())),
          BlocProvider(
            create: (BuildContext context) =>
                JokeBloc(jokeRepository: jokesRepository),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Joke App',
            theme: ThemeData(
                primaryColor: Colors.lightBlue.shade300,
                accentColor: Colors.lightBlue.shade100,
                textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.lightBlue.shade200)),
            home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthFailure) {
                return LoginPage(
                  userRepository: _userRepository,
                );
              } else if (state is AuthSuccess) {
                return HomePage(
                  user: state.user,
                );
              } else {
                return Scaffold(
                  appBar: AppBar(),
                  body: Container(
                    child: Center(child: Text("Loading")),
                  ),
                );
              }
            })));
  }
}
