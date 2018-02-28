// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show Future, Stream;
import 'dart:convert' show json, UTF8;
import 'dart:io' show HttpClient;

import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;

/// PODO for questions
class Question {
  String question;
  bool answer;

  Question.fromJson(Map jsonMap) :
    question = jsonMap['question'],
    answer = jsonMap['answer'];

  String toString() {
    return '$question is $answer';
  }
}

Future<List<Question>> loadQuestionsLocally() async {
  final jsonString = await rootBundle.loadString('assets/questions.json');
  final questions = json.decode(jsonString);
  return questions.map(
        (q) => new Question.fromJson(q)
      ).toList();
}

Future<List<Question>> loadQuestionsNetwork() async {
  final req = await new HttpClient().getUrl(
    Uri.parse('https://raw.githubusercontent.com/mjohnsullivan/flutter_quiz/master/assets/questions.json')
  );
  final res = await req.close();
  final body = await res.transform(UTF8.decoder).join();
  final questions = json.decode(body);
  return questions.map(
    (q) => new Question.fromJson(q)
  ).toList();
}

Future<Stream<Question>> loadQuestionsNetworkAsStream() async {
  final uri = 'https://raw.githubusercontent.com/mjohnsullivan/flutter_quiz/master/assets/questions.json';
  var client = new http.Client();
  var streamedRes = await client.send(
    new http.Request('get', Uri.parse(uri))
  );
  return streamedRes.stream
    .transform(UTF8.decoder)
    .transform(json.decoder)
    .expand( (body) => body)
    .map( (q) => new Question.fromJson(q));
}