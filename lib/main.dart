// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'questions.dart';
import 'questions_dissmissible.dart';
import 'questions_buttons.dart';
import 'questions_pagable.dart';

void main() {
  runApp(new QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizPage = new QuizPage();

    return new MaterialApp(
      title: 'Flutter Quiz',
      theme: new ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Quiz'),
        ),
        body: new Padding(
          padding: new EdgeInsets.only(top: 25.0,),
          child: quizPage,
        ),
      ),
    );
  }
}

enum QuestionView { buttons, dissmissible, pagable }

class QuizPage extends StatefulWidget {
  @override
  createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int score;
  List<Question> questions;
  QuestionView questionView;

  @override
  initState() {
    super.initState();
    score = 0;
    questions = <Question>[];
    questionView = QuestionView.dissmissible;
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
        new Score(score, changeQuestionsView),
        new Expanded(
          child: questionWidget,
        ),
      ],
    );
  }
}

class Score extends StatelessWidget {
  Score(this.score, this.changeQuestionView);
  final int score;
  final Function changeQuestionView;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Center(
            child: new Text(
              'Score: $score',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        new IconButton(
          icon: new Icon(Icons.list),
          onPressed: () => changeQuestionView(),
        ),
      ],
    );
  }
}