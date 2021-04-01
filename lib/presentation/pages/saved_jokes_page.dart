import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:joke_app/data/models/saved_joke.dart';

class SavedJokesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Box<SavedJoke> jokesBox = Hive.box<SavedJoke>('jokes');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Saved Jokes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              jokesBox.getAt(0).body,
              style: TextStyle(
                  color: Colors.lightBlue.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
