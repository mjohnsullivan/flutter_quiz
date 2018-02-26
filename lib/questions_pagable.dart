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

    var controller = new PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: 1.0,
    );

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
      color: Colors.blue,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            question.question,
            style: new TextStyle(fontSize: 18.0),
          ),
          new FlatButton(
            child: new Text('True'),
            onPressed: () => answerQuestion(question, true),
          ),
          new FlatButton(
            child: new Text('False'),
            onPressed: () => answerQuestion(question, false),
          ),
        ],
      ),
    );
  }

  
}