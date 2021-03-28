import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/blocs/authentication/auth_bloc.dart';
import 'package:joke_app/blocs/joke/joke_bloc.dart';
import 'package:joke_app/presentation/widgets/joke_card.dart';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLoggedOut());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<JokeBloc, JokeState>(
              builder: (BuildContext context, JokeState state) {
            if (state is JokeLoadingError) {
              return JokeCard(
                text: 'oops, Something went wrong! check your internet.',
                color: Colors.redAccent.shade400,
              );
            } else if (state is JokeLoadingState) {
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightBlue.shade300),
                  ),
                ),
              );
            } else if (state is JokeLoadedState) {
              return JokeCard(
                text: BlocProvider.of<JokeBloc>(context).joke.joke,
                color: Colors.lightBlue.shade500,
              );
            } else {
              return JokeCard(
                text: 'You wanna read a joke ? Tap the button below.',
                color: Colors.lightBlue.shade500,
              );
            }
          }),
          SizedBox(height: 24),
          _getJokeButton(context),
        ],
      ),
    );
  }

  GestureDetector _getJokeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<JokeBloc>(context)
            .add(GetJokeEvent(filters: ['racist']));
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.lightBlue.shade400,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            'Get Random Joke',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.6),
          )),
    );
  }
}
