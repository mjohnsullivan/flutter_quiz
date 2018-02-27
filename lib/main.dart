// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'questions.dart';
import 'questions_dissmissible.dart';
import 'questions_buttons.dart';
import 'questions_pagable.dart';

void main() {
  runApp(new QuizApp());
}

class QuizApp extends StatelessWidget {
  final viewChangeStreamController = new StreamController<Null>();


  _quizViewChange() {
    viewChangeStreamController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Quiz',
      theme: new ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Quiz'),
          elevation: 0.0,
          actions: [new IconButton(
            icon: new Icon(Icons.list),
            tooltip: 'Change quiz view',
            onPressed: _quizViewChange,
          )],
        ),
        body: new Padding(
          padding: new EdgeInsets.only(top: 5.0,),
          child: new QuizPage(viewChangeStreamController.stream),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

enum QuestionView { buttons, dissmissible, pagable }

class QuizPage extends StatefulWidget {
  QuizPage(this.viewChangeStream);
  final Stream<Null> viewChangeStream;

  @override
  createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  var score = 0;
  var questions = <Question>[];
  var questionView = QuestionView.dissmissible;
  StreamSubscription viewChangeSubscription;

  @override
  initState() {
    super.initState();
    _subscribeToViewChanges();
    _loadQuestions();
  }

  @override
  dispose() {
    super.dispose();
    if (widget.viewChangeStream != null) {
      viewChangeSubscription.cancel();
    }
  }

  _subscribeToViewChanges() {
    viewChangeSubscription = widget.viewChangeStream.listen((_) => changeQuestionsView());
  }

  _loadQuestions() async {
    final loadedQuestions = await loadQuestionsLocally();
    setState(() => questions = loadedQuestions);
  }

  _resetGame() => setState(() {
    score = 0;
    _loadQuestions();
  });

  _answerQuestion(Question question, bool answer) async {
    setState(() => question.answer == answer ? score++ : score--);

    questions.remove(question);
    if (questions.length == 0) {
      await _gameOverDialog();
      _resetGame();
    }
  }

  _gameOverDialog() async {
    return showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: new Text('Game Over'),
        content: new Text('You scored $score'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Change between the different question views
  changeQuestionsView() {
    setState(() => 
    questionView = QuestionView.values[
      (questionView.index + 1) % QuestionView.values.length]
    );
    print(questionView);
  }

  @override
  Widget build(BuildContext context) {
    Widget questionWidget;
    switch(questionView) {
      case QuestionView.dissmissible:
        questionWidget = new QuestionsDissmissible(questions, _answerQuestion);
        break;
      case QuestionView.buttons:
        questionWidget = new QuestionsButtons(questions, _answerQuestion);
        break;
      case QuestionView.pagable:
        questionWidget = new QuestionsPageable(questions, _answerQuestion);
        break;
    }
    return new Column(
      children: [
        new Score(score),
        new Expanded(
          child: questionWidget,
        ),
      ],
    );
  }
}

class Score extends StatelessWidget {
  Score(this.score);
  final int score;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(
        'Score: $score',
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}