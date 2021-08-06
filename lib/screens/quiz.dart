import 'package:flutter/material.dart';
import 'question.dart';
import 'answers.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> question;

  final Function answerQuestion;
  final int questionIndex;

  Quiz({
    @required this.question,
    @required this.answerQuestion,
    @required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
          ),
          Question(question[questionIndex]['questionText']),
          SizedBox(
            width: 50,
            height: 50,
          ),
          ...(question[questionIndex]['answers'] as List<String>).map((answer) {
            return Answers(answerQuestion, answer);
          }).toList()
        ],
      ),
    );
  }
}
