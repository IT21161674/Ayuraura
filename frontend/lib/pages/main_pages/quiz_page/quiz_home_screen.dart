import 'package:flutter/material.dart';
import 'package:stress_management/pages/main_pages/quiz_page/quiz_screen.dart';
import '../../../constants/colors.dart';

class QuizHomeScreen extends StatelessWidget {
  // Define the theme color
  final Color themeColor = Color(0xFF4CAF50); // #4CAF50
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeColor.withOpacity(0.1),
              themeColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hey there! Let's check in on your journey to a stress-free life.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
//                   color: themeColor.shade100,
                ),
              ),
//               SizedBox(height: 10),
//               Text(
//                 'Your progress matters! Let's see how you're feeling and predict your path to a stress-free mind.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, color: Colors.black87),
//               ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  "Your progress matters! Lets see how you are feeling and predict your path to a stress-free mind. 🌿",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: themeColor),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Column(
                  children: [
                    Text('Your daily emotions help shape your recovery journey!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _moodOption(Icons.wb_sunny, "Great", Colors.orange),
                        _moodOption(Icons.sentiment_satisfied, "Good", Colors.green),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _moodOption(Icons.cloud, "Okay", Colors.blue),
                        _moodOption(Icons.emoji_emotions_outlined, "Not Great", Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Let's find out! Log Your Answers Now", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Column(
                  children: [
                    Text(
                      "Today's Stress-Free Insight ✨",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Taking a moment to reflect on your emotions can help improve your mental well-being. Remember to be kind to yourself today! 💚',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ), ],), ), ], ), ), ), );
  }

  Widget _moodOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
