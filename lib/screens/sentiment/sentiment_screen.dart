import 'package:flutter/material.dart';

class SentimentScreen extends StatelessWidget {
  static const id = 'sentiment_screen';
  final double sentimentValue;
  const SentimentScreen({
    Key? key,
    required this.sentimentValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getEmoji(sentimentValue),
              style: TextStyle(fontSize: size.width * 0.3),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'On a scale of \n-1 (saddest) to 1 (happiest), \nyour text is',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              sentimentValue.toStringAsFixed(4),
              style: const TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'BACK',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getEmoji(double sentimentValue) {
    if (sentimentValue < -0.2) {
      return '😔';
    } else if (sentimentValue < 0.2) {
      return '😐';
    } else {
      return '😁';
    }
  }
}
