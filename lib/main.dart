// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'questions.dart';

void main() {
  runApp(new QuizApp());
}

class QuizApp extends StatelessWidget {
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
    final loadedQuestions = await loadQuestionsLocally();
    setState(() => questions = loadedQuestions);
  }

  _incrementScore() => setState(() => ++score);

  _decrementScore() => setState(() => --score);

  _resetGame() => setState(() {
    score = 0;
    _loadQuestions();
  });

  _answerQuestion(Question question, bool answer) async {
    question.answer == answer ?
      _incrementScore() :
      _decrementScore();

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

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        new Score(score),
        new Expanded(
          child: new QuestionsDissmissible(questions, _answerQuestion),
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
          child: new QuestionTile(question),
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

class QuestionTile extends StatelessWidget {
  QuestionTile(this.question);
  final Question question;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text('Q'),
      ),
      title: new Text(question.question),
      subtitle: new Text('Swipe right for true, left for false'),
    );
  }
}
