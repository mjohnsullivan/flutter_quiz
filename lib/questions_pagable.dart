// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'questions.dart';

class QuestionsPageable extends StatelessWidget {
  QuestionsPageable(this.questions, this.answerQuestion) :
    questionPages = questions.map((q) => new QuestionPage(q, answerQuestion)).toList();
  
  final List<Question> questions;
  final Function(Question, bool) answerQuestion;
  final List<Widget> questionPages;

  @override
  Widget build(BuildContext context) {

    var controller = new PageController();

    return new PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      children: questionPages,
      onPageChanged: (i) => print('Page changed to $i'),
      
    );
  }
}

class QuestionPage extends StatelessWidget {
  QuestionPage(this.question, this.answerQuestion);
  final Question question;
  final Function(Question, bool) answerQuestion;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            question.question,
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 30.0),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new FlatButton(
                child: new Text('TRUE'),
                splashColor: Colors.blue,
                onPressed: () => answerQuestion(question, true),
              ),
              new FlatButton(
                child: new Text('FALSE'),
                splashColor: Colors.blue,
                onPressed: () => answerQuestion(question, false),
              ),
            ],
          ),
        ],
      ),
    );
  }  
}