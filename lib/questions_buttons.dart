// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'questions.dart';

class QuestionsButtons extends StatelessWidget {
  QuestionsButtons(this.questions, this.answerQuestion);
  final List<Question> questions;
  final Function(Question, bool) answerQuestion;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((q) =>
        new QuestionButtonsTile(q, answerQuestion)).toList()
    );
  }
}

class QuestionButtonsTile extends StatelessWidget {
  QuestionButtonsTile(this.question, this.answerQuestion);
  final Question question;
  final Function(Question, bool) answerQuestion;

  Widget build(BuildContext context) {
    return new Card(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Expanded(
              child: new Text(
                question.question,
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          new GestureDetector(
            child: new Container(
              padding: new EdgeInsets.all(20.0),
              color: Colors.green,
              child: new Icon(
                Icons.check,
                color: Theme.of(context).canvasColor,
              ),
            ),
            onTap: () => answerQuestion(question, true),
          ),
          new GestureDetector(
            child: new Container(
              padding: new EdgeInsets.all(20.0),
              color: Colors.red,
              child: new Icon(
                Icons.clear,
                color: Theme.of(context).canvasColor,
              ),
            ),
            onTap: () => answerQuestion(question, false),
          ),
        ]
      ),
    );
  }
}