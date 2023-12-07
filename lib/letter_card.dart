import 'package:flutter/material.dart';

class LetterCard extends StatelessWidget {
  final String? letter;
  final String? imagePath;

  const LetterCard({this.letter, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (letter != null && letter!.isNotEmpty)
            Text(
              letter!,
              style: TextStyle(fontSize: 24.0),
            ),
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 100.0,
              width: 100.0,
            ),
        ],
      ),
    );
  }
}
