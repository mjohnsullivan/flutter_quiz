// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;

/// PODO for questions
class Question {
  String question;
  bool answer;

  Question.fromJson(Map jsonMap) :
    question = jsonMap['question'],
    answer = jsonMap['answer'];
}

Future<List<Question>> loadQuestionsLocally() async {
   final jsonString = await rootBundle.loadString('assets/questions.json');
  final questions = json.decode(jsonString);
  return questions.map(
        (q) => new Question.fromJson(q)
      ).toList();
}