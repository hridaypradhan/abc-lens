import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:text_analyzer/global/text_analysis.dart';
import 'package:text_analyzer/screens/sentiment/sentiment_screen.dart';
import 'package:text_analyzer/screens/summary/summary_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class OcrTextWidget extends StatelessWidget {
  final OcrText ocrText;

  const OcrTextWidget(this.ocrText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.title),
      title: Text(ocrText.value),
      subtitle: Text(ocrText.language),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () async {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          context: context,
          builder: (context) => Wrap(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Bounce(
                      duration: const Duration(milliseconds: 200),
                      onPressed: () async {
                        var data = await sentimentAnalysis(
                          'sentiment',
                          ocrText.value,
                        );
                        var decodedData = jsonDecode(data);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SentimentScreen(
                              sentimentValue: decodedData['sentiment_value'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.red[100],
                        ),
                        child: const Text(
                          'SENTIMENT ANALYSIS',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.all(15.0),
                      ),
                    ),
                    Bounce(
                      duration: const Duration(milliseconds: 200),
                      onPressed: () async {
                        var data = await summarize(
                          'summarize',
                          ocrText.value,
                        );
                        var decodedData = jsonDecode(data);
                        if (decodedData['summary'].isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                text: decodedData['summary'],
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.green[200],
                        ),
                        child: const Text(
                          'SUMMARIZE',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.all(15.0),
                      ),
                    ),
                    Bounce(
                      duration: const Duration(milliseconds: 200),
                      onPressed: () async {
                        String url =
                            'https://www.google.com/search?q=${ocrText.value}';
                        await launch(url);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.orange[200],
                        ),
                        child: const Text(
                          'GOOGLE SEARCH',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.all(15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
