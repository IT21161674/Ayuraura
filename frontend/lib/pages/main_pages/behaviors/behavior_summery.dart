import 'package:flutter/material.dart';
import 'package:stress_management/pages/main_pages/behaviors/PredictionPage.dart'; // Import PredictionPage

class BehaviorSummery extends StatelessWidget {
  final Map<int, double> answers;
  final List<Map<String, dynamic>> questions;

  const BehaviorSummery({
    Key? key,
    required this.answers,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnswersSection(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to PredictionPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionPage(
                      answers: answers,
                      questions: questions,
                    ),
                  ),
                );
              },
              child: const Text('Confirm and View Prediction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswersSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your Answers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(questions[index]['text']),
                trailing: Text(
                  answers[index]?.toStringAsFixed(1) ?? '0.0',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}