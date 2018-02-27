import 'package:flutter/material.dart';

import '../questions.dart';

class QuizAppSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Quiz',
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Quiz Skeleton'),
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
          child: new ListView(
            children: questions.map((question) => new Text(question.question)).toList()
          ),
        ),
      ],
    );
  }
}