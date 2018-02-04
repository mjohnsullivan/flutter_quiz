// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert' show JSON;
import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Quiz',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Padding(
          padding: new EdgeInsets.only(top: 25.0,),
          child: new QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  QuizPage() : super(key: new GlobalKey());

  @override
  createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int score;
  List<Question> questions;

  @override
  initState() {
    super.initState();
    score = 0;
    questions = <Question>[];
    _loadQuestions();
  }

  _loadQuestions() async {
    var jsonString = await rootBundle.loadString('assets/questions.json');
    var questionList = JSON.decode(jsonString);
    setState(() =>
      questions = questionList.map((q) => new Question.fromJson(q)).toList()
    );
  }

  void incrementScore() => setState(() => ++score);
  void decrementScore() => setState(() => --score);
  void resetGame() => setState(() {
    score = 0;
    _loadQuestions();
  });

  answerQuestion(Question question, bool answer) async {
    question.answer == answer ?
      incrementScore() :
      decrementScore();
    questions.remove(question);
    // If there are no more questions, game over
    if (questions.length == 0) {
      await _gameOverDialog();
      resetGame();
    }
  }

  Future<Null> _gameOverDialog() async {
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

  @override
  Widget build(BuildContext context) {
    return  new Column(
      children: [
        new Score(score),
        new Expanded(
          child: new Questions(questions, answerQuestion),
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
    return new Text(
      'Score: $score',
      style: Theme.of(context).textTheme.display1,
    );
  }
}

class Questions extends StatelessWidget {
  Questions(this.questions, this.answerQuestion);
  final List<Question> questions;
  final Function(Question, bool) answerQuestion;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((q) =>
        new QuestionTile(q, answerQuestion)).toList()
    );
  }
}

class QuestionTile extends StatelessWidget {
  QuestionTile(this.question, this.answerQuestion);
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

/// PODO for questions
class Question {
  String question;
  bool answer;

  Question.fromJson(Map jsonMap) :
    question = jsonMap['question'],
    answer = jsonMap['answer'];
}