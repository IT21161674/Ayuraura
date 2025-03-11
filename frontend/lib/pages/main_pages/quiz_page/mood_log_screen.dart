import 'package:stress_management/pages/main_pages/quiz_page/progress_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'daily_reminder_screen.dart';



class MoodLogScreen extends StatefulWidget {
  const MoodLogScreen({Key? key}) : super(key: key);

  @override
  State<MoodLogScreen> createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🌟 \"Your Personalized Stress-Free Plan\"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              '\"Here’s what we recommend to help you feel your best!\"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '🗓 \"It will take approximately 7 days to feel completely stress-free.\"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => QuizScreen(),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                '🟢 Start My Stress-Free Journey',
                style: TextStyle(fontSize: 18, color: AppColors.secondary),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgressScreen(),
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
                '🔵 View Progress',
                style: TextStyle(fontSize: 18, color: AppColors.secondary),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyReminder(),
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
                '🔁 Log Emotions Again Tomorrow',
                style: TextStyle(fontSize: 18, color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
