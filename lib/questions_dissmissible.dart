// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'questions.dart';

class QuestionsDissmissible extends StatelessWidget {
  QuestionsDissmissible(this.questions, this.answerQuestion);
  final List<Question> questions;
  final Function(Question, bool) answerQuestion;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((question) =>
        new Dismissible(
          key: new Key(question.question),
          child: new QuestionDissmissibleTile(question),
          background: new Container(
            color: Colors.green,
            child: new Padding(
              padding: new EdgeInsets.only(left: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Icon(
                    Icons.check,
                    size: 50.0,
                    color: Theme.of(context).canvasColor,
                  ),
                ],
              ),
            ),
          ),
          secondaryBackground: new Container(
            color: Colors.red,
            child: new Padding(
              padding: new EdgeInsets.only(right: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Icon(
                    Icons.clear,
                    size: 50.0,
                    color: Theme.of(context).canvasColor,
                  ),
                ],
              ),
            ),
          ),
          onDismissed: (direction) => direction == DismissDirection.startToEnd
            ? answerQuestion(question, true)
            : answerQuestion(question, false),
        ),
      ).toList(),
    );
  }
}

class QuestionDissmissibleTile extends StatelessWidget {
  QuestionDissmissibleTile(this.question);
  final Question question;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text('Q'),
        backgroundColor: Colors.blue,
      ),
      title: new Text(question.question),
      subtitle: new Text('Swipe right for true, left for false'),
    );
  }
}