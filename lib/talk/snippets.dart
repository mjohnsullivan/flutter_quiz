/// command<k> command<1> to shrink all

import 'package:flutter/material.dart';

// hello world minimal
main() {
  runApp(
    new Center(
      child: new Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}

// hello world scaffolded
class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hello World',
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Hello World'),
        ),
        body: const Center(
          child: const Text('Hello World'),
        ),
      ),
    );
  }
}

// Questions PODO
class Question {
  String question;
  bool answer;

  Question.fromJson(Map jsonMap)
      : question = jsonMap['question'],
        answer = jsonMap['answer'];

  String toString() {
    return '$question is $answer';
  }
}

// quiz app skeleton
class QuizPage extends StatefulWidget {
  @override
  createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  var score = 0;
  var questions = <Question>[];

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Center(
          child: new Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: new Text(
              'Score: $score',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        new Expanded(
          child: new ListView(
            children: questions.map((q) => new Text(q.question)).toList(),
          ),
        ),
      ],
    );
  }
}

// load questions locally
Future<List<Question>> loadQuestionsLocally() async {
  final jsonString = await rootBundle.loadString('assets/questions.json');
  final questions = json.decode(jsonString);
  return questions.map((q) => new Question.fromJson(q)).toList();
}

// load questions remotely
Future<List<Question>> loadQuestionsNetwork() async {
  final res = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/mjohnsullivan/flutter_quiz/master/assets/questions.json'));
  final questions = json.decode(res.body);
  return questions.map((q) => new Question.fromJson(q)).toList();
}

// load questions into state
@override
initState() {
  super.initState();
  _loadQuestions();
}

_loadQuestions() async {
  var loadedQuestions = await loadQuestionsLocally();
  setState(() => questions = loadedQuestions);
}

// layout questions
class Questions extends StatelessWidget {
  Questions(this.questions);
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((q) {
        final controls = new Row(
          children: [
            new Icon(Icons.check),
            new Icon(Icons.clear),
          ],
        );

        return new ListTile(
          leading: new CircleAvatar(
            child: new Text('Q'),
          ),
          title: new Text(q.question),
          trailing: controls,
        );
      }).toList(),
    );
  }
}

// gestures
final controls = new Row(
  children: [
    new GestureDetector(
      child: new Icon(Icons.check),
      onTap: () => print('true'),
    ),
    new IconButton(
      icon: new Icon(Icons.clear),
      onPressed: () => print('false'),
    ),
  ],
);

// answer question Function
answerQuestion(Question question, bool answer) {
  setState(() {
    question.answer == answer ? score++ : score--;
    questions.remove(question);
  });
}

// questions with interactivity
class Questions extends StatelessWidget {
  Questions(this.questions, this.answerQuestion);
  final List<Question> questions;
  final Function(Question, bool) answerQuestion;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: questions.map((q) {
        final controls = new Row(
          children: [
            new GestureDetector(
              child: new Icon(Icons.check),
              onTap: () => answerQuestion(q, true),
            ),
            new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: () => answerQuestion(q, false),
            ),
          ],
        );

        return new ListTile(
          leading: new CircleAvatar(
            child: new Text('Q'),
          ),
          title: new Text(q.question),
          trailing: controls,
        );
      }).toList(),
    );
  }
}

// dialog
_resetGame() {
  setState(() {
    score = 0;
    _loadQuestions();
  });
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

// paging
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