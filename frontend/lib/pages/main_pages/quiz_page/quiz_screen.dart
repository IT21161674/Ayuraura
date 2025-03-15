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
      "😰 I feel extremely anxious and unable to cope with daily tasks.",
      "😟 I feel quite overwhelmed and find it hard to relax.",
      "😐 I’m aware of some stress but I’m managing okay.",
      "🙂 I have a few minor concerns but feel generally fine.",
      "😌 I’m completely relaxed and worry-free."
    ]),
    Question("How happy do you feel today?", [
      "😐 I feel mostly unhappy or neutral.",
      "🙂 I feel a little happy, but nothing special.",
      "😊 I feel generally happy and content.",
      "😄 I feel very happy and positive about my day.",
      "🤩 I’m bursting with joy and feeling ecstatic!"
    ]),
    Question("How calm and relaxed do you feel?", [
      "😫 I feel very agitated or anxious.",
      "😟 I feel a bit uneasy but not too stressed.",
      "😌 I feel generally calm and at ease.",
      "🧘‍♂️ I feel very relaxed and peaceful.",
      "🌅 I’m completely serene and tranquil."
    ]),
    Question("How energetic are you feeling right now?", [
      "😴 I feel very low on energy and sluggish.",
      "😪 I have a bit of energy, but mostly tired.",
      "🙂 I have enough energy to get through the day.",
      "💪 I feel quite energetic and active.",
      "⚡ I’m full of energy and ready for anything!"
    ]),
  ];

  late List<String> selectedAnswers;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedAnswers = widget.initialAnswers ?? List.filled(questions.length, "");
  }

  void navigateToResults() {
    if (selectedAnswers.contains("")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please answer all questions before submitting."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(selectedAnswers: selectedAnswers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Stress Check-Up!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 20),
//               Text(
//                 'Question \${currentIndex + 1} of \${questions.length}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
//               ),
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                Question question = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.green.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.questionText,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        ...question.answers.map((answer) {
                          return RadioListTile<String>(
                            title: Text(
                              answer,
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            value: answer,
                            groupValue: selectedAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[index] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToResults,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
