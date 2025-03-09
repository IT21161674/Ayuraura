import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BehaviorSummery extends StatefulWidget {
  final Map<int, double> answers;
  final List<Map<String, dynamic>> questions;

  const BehaviorSummery({
    Key? key,
    required this.answers,
    required this.questions,
  }) : super(key: key);

  @override
  State<BehaviorSummery> createState() => _BehaviorSummeryState();
}

class _BehaviorSummeryState extends State<BehaviorSummery> {
  late Future<Map<String, dynamic>> _predictionFuture;
  final String _backendUrl = 'https://244e-35-227-146-21.ngrok-free.app/predict';

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
      appBar: AppBar(title: const Text('Summary & Prediction')),
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
          _buildAnswersSection(),
          const SizedBox(height: 24),
          _buildPredictionSection(prediction),
          if (predictedClass == 'Stress') const SizedBox(height: 24),
          if (predictedClass == 'Stress') _buildRecommendationsSection(recommendations),
        ],
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
              itemCount: widget.questions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(widget.questions[index]['text']),
                trailing: Text(
                  widget.answers[index]?.toStringAsFixed(1) ?? '0.0',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionSection(Map<String, dynamic> prediction) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Stress Prediction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${prediction['predicted_class']}',
              style: TextStyle(
                fontSize: 18,
                color: prediction['predicted_class'] == 'Stress'
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildProbabilityIndicator(
              label: 'No Stress',
              value: prediction['probabilities']['No Stress'],
              color: Colors.green,
            ),
            _buildProbabilityIndicator(
              label: 'Stress',
              value: prediction['probabilities']['Stress'],
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityIndicator({
    required String label,
    required String value,
    required Color color,
  }) {
    final percentage = double.parse(value.replaceAll('%', ''));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $value', style: TextStyle(fontSize: 16, color: color)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
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