import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final Color color;
  final String text;

  const JokeCard({Key key, this.color, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2), color: Colors.black45, blurRadius: 6)
          ]),
      child: Text(
        text,
        style: TextStyle(
            color: color,
            fontSize: 18,
            letterSpacing: 1,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
