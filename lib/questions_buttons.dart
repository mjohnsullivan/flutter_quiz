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
    final listTiles = questions.map((question) {

      final controls = new Row(
        children: [
          new GestureDetector(
            child: new Icon(Icons.check, size: 30.0),
            onTap: () => answerQuestion(question, true),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 10.0),
            child: new GestureDetector(
              child: new Icon(Icons.clear, size: 30.0),
              onTap: () => answerQuestion(question, false),
            ),
          ),
        ],
      );

      return new ListTile(
        leading: new CircleAvatar(
          child: const Text('Q'),
          backgroundColor: Colors.blue,
        ),
        title: new Text(question.question),
        trailing: controls,
      );
    }).toList();

    return new ListView(
      children: listTiles
    );
  }
}