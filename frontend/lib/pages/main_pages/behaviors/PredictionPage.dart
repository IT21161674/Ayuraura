import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  final Map<int, double> answers;
  final List<Map<String, dynamic>> questions;

  const PredictionPage({
    Key? key,
    required this.answers,
    required this.questions,
  }) : super(key: key);

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  late Future<Map<String, dynamic>> _predictionFuture;
  final String _backendUrl = 'https://1438-35-231-230-9.ngrok-free.app/predict';

  @override
  void initState() {
    super.initState();
    _predictionFuture = _fetchPrediction();
  }

  Future<Map<String, dynamic>> _fetchPrediction() async {
    final parameterNames = [
      'avg_sleep_hours_per_night',
      'avg_exercise_days_per_week',
      'avg_work_or_study_hours_per_week',
      'avg_screen_hours_per_day',
      'social_interaction_quality_rating',
      'diet_healthiness_rating',
      'smoking_drinking_habits_rating',
      'avg_recreational_hours_per_week',
    ];

    final Map<String, dynamic> requestBody = {};
    for (int i = 0; i < parameterNames.length; i++) {
      requestBody[parameterNames[i]] = widget.answers[i]?.toDouble() ?? 0.0;
    }

    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  List<String> generateRecommendations(Map<int, double> answers, String predictedClass) {
    List<String> recommendations = [];

    // Only generate recommendations if the predicted class is "Stress"
    if (predictedClass != 'Stress') {
      return recommendations;
    }

    double avgSleepHoursPerNight = answers[0] ?? 0.0;
    double avgExerciseDaysPerWeek = answers[1] ?? 0.0;
    double avgWorkOrStudyHoursPerWeek = answers[2] ?? 0.0;
    double avgScreenHoursPerDay = answers[3] ?? 0.0;
    double socialInteractionQualityRating = answers[4] ?? 0.0;
    double dietHealthinessRating = answers[5] ?? 0.0;
    double smokingDrinkingHabitsRating = answers[6] ?? 0.0;
    double avgRecreationalHoursPerWeek = answers[7] ?? 0.0;

    // Sleep recommendations
    if (avgSleepHoursPerNight < 6.5) {
      double difference = 6.5 - avgSleepHoursPerNight;
      recommendations.add('Increase sleep by at least ${difference.toStringAsFixed(1)} hours per night.');
    }

    // Exercise recommendations
    if (avgExerciseDaysPerWeek < 3) {
      double difference = 3 - avgExerciseDaysPerWeek;
      recommendations.add('Increase exercise by at least ${difference.toStringAsFixed(1)} days per week.');
    }

    // Work/Study recommendations
    if (avgWorkOrStudyHoursPerWeek > 45) {
      double difference = avgWorkOrStudyHoursPerWeek - 45;
      recommendations.add('Reduce work/study hours by at least ${difference.toStringAsFixed(1)} hours per week.');
    }

    // Screen time recommendations
    if (avgScreenHoursPerDay > 6) {
      double difference = avgScreenHoursPerDay - 6;
      recommendations.add('Reduce screen time by at least ${difference.toStringAsFixed(1)} hours per day.');
    }

    // Social interaction recommendations
    if (socialInteractionQualityRating <= 5) {
      recommendations.add('Improve social interaction quality.');
    }

    // Diet recommendations
    if (dietHealthinessRating <= 5) {
      recommendations.add('Increase the healthiness of your diet.');
    }

    // Smoking/Drinking recommendations
    if (smokingDrinkingHabitsRating >= 4) {
      recommendations.add('Reduce smoking and drinking habits.');
    }

    // Recreational activities recommendations
    if (avgRecreationalHoursPerWeek < 7) {
      double difference = 7 - avgRecreationalHoursPerWeek;
      recommendations.add('Increase recreational activities by at least ${difference.toStringAsFixed(1)} hours per week.');
    }

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction & Recommendations')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _predictionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorSection(snapshot.error.toString());
          }

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> prediction) {
    final predictedClass = prediction['predicted_class'];
    final recommendations = generateRecommendations(widget.answers, predictedClass);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image at the top half of the page
          Image.asset(
            predictedClass == 'Stress'
                ? 'assets/behaviors/stress_image.png' // Image for stress
                : 'assets/behaviors/no_stress_image.png', // Image for no stress
            height: 300, // Adjust height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          _buildPredictionSection(prediction),
          if (predictedClass == 'Stress') const SizedBox(height: 24),
          if (predictedClass == 'Stress') _buildRecommendationsSection(recommendations),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the main page
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Return to Main Page'),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionSection(Map<String, dynamic> prediction) {
    final predictedClass = prediction['predicted_class'];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Prediction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              predictedClass == 'Stress'
                  ? 'Your behaviors suggest a high risk of future stress.'
                  : 'Your behaviors indicate a low risk of future stress.',
              style: TextStyle(
                fontSize: 18,
                color: predictedClass == 'Stress' ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(List<String> recommendations) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Text(
                'No specific recommendations at this time.',
                style: TextStyle(fontSize: 16),
              ),
            if (recommendations.isNotEmpty)
              ...recommendations.map((recommendation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_forward, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            const Text(
              'Failed to get prediction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _predictionFuture = _fetchPrediction()),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}