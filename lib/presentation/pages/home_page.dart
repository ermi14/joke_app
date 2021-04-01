import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:joke_app/blocs/authentication/auth_bloc.dart';
import 'package:joke_app/blocs/joke/joke_bloc.dart';
import 'package:joke_app/data/models/saved_joke.dart';
import 'package:joke_app/presentation/widgets/joke_card.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<SavedJoke> jokesBox;
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
                child: _buildShimmer(),
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
          SizedBox(
            height: 12,
          ),

          /////////// Save to local db(hive)
          GestureDetector(
              onTap: () async {
                try {
                  if (Hive.isBoxOpen('jokes')) {
                    jokesBox = Hive.box<SavedJoke>('jokes');
                    jokesBox.put(
                      BlocProvider.of<JokeBloc>(context).joke.id,
                      SavedJoke(
                        id: BlocProvider.of<JokeBloc>(context)
                            .joke
                            .id
                            .toString(),
                        body: BlocProvider.of<JokeBloc>(context).joke.joke,
                      ),
                    );

                    print(jokesBox
                        .get(BlocProvider.of<JokeBloc>(context).joke.id));
                  } else {
                    print('Box is not opened');
                  }
                } catch (err, stackTrace) {
                  print(err.message);
                  print(stackTrace);
                }
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
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.6),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2), color: Colors.black45, blurRadius: 6)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 180,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
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
