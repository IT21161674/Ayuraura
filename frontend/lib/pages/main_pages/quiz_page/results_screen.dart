import 'package:stress_management/pages/main_pages/quiz_page/quiz_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'mood_log_screen.dart';


class ResultsScreen extends StatelessWidget {
  final List<String> selectedAnswers;

  ResultsScreen({required this.selectedAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Emotional Summary for Today',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ...selectedAnswers.asMap().entries.map((entry) {
                int index = entry.key;
                String answer = entry.value;
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
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
                      child: Text(
                        '$answer',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      width: double.maxFinite,
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoodLogScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save My Mood Log 💾',
                  style: TextStyle(fontSize: 18, color: AppColors.secondary,),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        initialAnswers: selectedAnswers,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Edit My Answers ✏️',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
