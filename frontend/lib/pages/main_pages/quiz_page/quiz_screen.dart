import 'package:stress_management/pages/main_pages/quiz_page/results_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../models/question_model/question.dart';


class QuizScreen extends StatefulWidget {
  final List<String>? initialAnswers;

  QuizScreen({this.initialAnswers});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> questions = [
    Question("How much pressure are you feeling right now?", [
      "1. 😰 I feel extremely anxious and unable to cope with daily tasks.",
      "2. 😟 I feel quite overwhelmed and find it hard to relax.",
      "3. 😐 I’m aware of some stress but I’m managing okay.",
      "4. 🙂 I have a few minor concerns but feel generally fine.",
      "5. 😌 I’m completely relaxed and worry-free."
    ]),
    Question("How happy do you feel today?", [
      "1. 😐 I feel mostly unhappy or neutral.",
      "2. 🙂 I feel a little happy, but nothing special.",
      "3. 😊 I feel generally happy and content.",
      "4. 😄 I feel very happy and positive about my day.",
      "5. 🤩 I’m bursting with joy and feeling ecstatic!"
    ]),
    Question("How calm and relaxed do you feel?", [
      "1. 😫 I feel very agitated or anxious.",
      "2. 😟 I feel a bit uneasy but not too stressed.",
      "3. 😌 I feel generally calm and at ease.",
      "4. 🧘‍♂️ I feel very relaxed and peaceful.",
      "5. 🌅 I’m completely serene and tranquil."
    ]),
    Question("How energetic are you feeling right now?", [
      "1. 😴 I feel very low on energy and sluggish.",
      "2. 😪 I have a bit of energy, but mostly tired.",
      "3. 🙂 I have enough energy to get through the day.",
      "4. 💪 I feel quite energetic and active.",
      "5. ⚡ I’m full of energy and ready for anything!"
    ]),
  ];

  late List<String> selectedAnswers;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedAnswers =
        widget.initialAnswers ?? List.filled(questions.length, "");
  }

  void nextQuestion(String answer) {
    selectedAnswers[currentQuestionIndex] = answer;
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(selectedAnswers: selectedAnswers),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\"${questions[currentQuestionIndex].questionText}\"",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: questions[currentQuestionIndex].answers.map((answer) {
                    return Column(
                      children: [
                        RadioListTile<String>(
                          title: Text(
                            answer,
                            style: TextStyle(fontSize: 20),
                          ),
                          value: answer,
                          groupValue: selectedAnswers[currentQuestionIndex],
                          onChanged: (value) {
                            setState(() {
                              selectedAnswers[currentQuestionIndex] = value!;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of 4',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedAnswers[currentQuestionIndex].isNotEmpty) {
                        nextQuestion(selectedAnswers[currentQuestionIndex]);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.secondary,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex == questions.length - 1
                          ? 'Finish'
                          : 'Next',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
