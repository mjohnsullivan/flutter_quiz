import 'dart:convert' show JSON;

import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  // enableFlutterDriverExtension();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: new Score(
        key: new GlobalKey(),
        child: new Column(
          children: [
            new ScoreTile(),
            new Expanded(
              child: new Questions(),
            ),
          ],
        ),
      ),
    );
  }
}

/// See https://stackoverflow.com/questions/43778488/force-flutter-to-redraw-all-widgets
class Score extends StatefulWidget {
  Score({Key key, this.child}) :
    super(key: key);
  
  final Widget child;

  @override
  createState() => new ScoreState(child);
}

class ScoreState extends State<Score> {
  ScoreState(this.child);

  final Widget child;
  int score = 0;

  void incrementScore() => setState(() => score++);

  void decrementScore() => setState(() => score--);

  @override
  Widget build(BuildContext context) {
    return new InheritedScore(stateKey: widget.key, score: score, child: child);
  }
}

class InheritedScore extends InheritedWidget {
  const InheritedScore({
    Key key,
    @required this.stateKey,
    @required this.score,
    @required Widget child,
  }) : assert(score != null),
       assert(stateKey != null),
       assert(child != null),
      super(key: key, child: child);

  final GlobalKey stateKey;
  final int score;

  @override
  bool updateShouldNotify(InheritedScore old) => score != old.score;

  static InheritedScore of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedScore);
  }
}

class ScoreTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int score = InheritedScore.of(context).score;
    return new Text(
      'Score: $score',
      style: Theme.of(context).textTheme.display1,
    );
  }
}

class Questions extends StatefulWidget {
  @override
  createState() => new QuestionsState();
}

class QuestionsState extends State<Questions> {
  var questions = <Question>[];

  @override
  initState() {
    super.initState();
    loadQuestions();
  }

  loadQuestions() async {
    var jsonString = await rootBundle.loadString('assets/questions.json');
    var questionList = JSON.decode(jsonString);
    setState(() =>
      questions = questionList.map((q) => new Question.fromJson(q)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((question) =>
        new Padding(
          padding: new EdgeInsets.only(top: 10.0, bottom: 10.0,),
          child: new Dismissible(
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
                    ),
                  ],
                ),
              ),
            ),
            onDismissed: (direction) => direction == DismissDirection.startToEnd
              ? questionAnswered(question, true)
              : questionAnswered(question, false),
          ),
        )
      ).toList(),
    );
  }

  void questionAnswered(Question question, bool answer) {
    questions.remove(question);
    GlobalKey stateKey = InheritedScore.of(context).stateKey;
    if (question.answer == answer) {
      (stateKey.currentState as ScoreState).incrementScore();
    } else {
      (stateKey.currentState as ScoreState).decrementScore();
    }
  }
}

/// Tile that displays a question
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

/// PODO for questions
class Question {
  String question;
  bool answer;

  Question.fromJson(Map jsonMap) :
    question = jsonMap['question'],
    answer = jsonMap['answer'];
}