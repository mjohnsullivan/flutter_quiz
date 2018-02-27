// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../questions.dart';

class QuizAppListTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Quiz',
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Quiz'),
        ),
        body: new QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  createState() => new QuizPageState();
  }
  
class QuizPageState extends State<QuizPage> {
  var score = 0;
  var questions = <Question>[];

  @override
  initState() {
    super.initState();
    _loadQuestions();
  }

  _loadQuestions() async {
    final loadedQuestions = await loadQuestionsLocally();
    setState(() => questions = loadedQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return 
    new Column(
      children: [
        new Text('Score: $score',
          style: Theme.of(context).textTheme.display1,
        ),
        new Expanded(
          child: new Questions(questions),
        ),
      ],
    );
  }
}

class Questions extends StatelessWidget {
  Questions(this.questions);
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {

    final controls = new Row(
      children: [
        new GestureDetector(
          child: new Icon(Icons.check, size: 30.0),
          onTap: () => print('true'),
        ),
        new GestureDetector(
          child: new Icon(Icons.clear, size: 30.0),
          onTap: () => print('false'),
        ),
      ]
    );

    final listTiles = questions.map((question) => 
      new ListTile(
        leading: new CircleAvatar(
          child: const Text('Q'),
        ),
        title: new Text(question.question),
        trailing: controls,
      )
    ).toList();

    final dividedTiles = ListTile.divideTiles(
      context: context,
      tiles: listTiles
    ).toList();

    return new ListView(children: dividedTiles);
  }
}