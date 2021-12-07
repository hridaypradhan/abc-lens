import 'dart:convert';
import 'package:http/http.dart';

const String baseUri = 'http://10.6.10.148:5000/';

Future sentimentAnalysis(String route, String toAnalyze) async {
  Response response = await post(
    Uri.parse(baseUri + route),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'to_analyze': toAnalyze,
      },
    ),
  );
  return response.body;
}

Future summarize(String route, String toSummarize) async {
  Response response = await post(
    Uri.parse(baseUri + route),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'to_summarize': toSummarize,
      },
    ),
  );
  return response.body;
}
