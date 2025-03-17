import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stress_management/constants/constants.dart';

import '../../../constants/colors.dart';
import 'eye_stress_level_screen.dart';

class StressScaleQuiz extends StatefulWidget {
  final File videoFile;
  const StressScaleQuiz({super.key, required this.videoFile});

  @override
  _StressScaleQuizState createState() => _StressScaleQuizState();
}

class _StressScaleQuizState extends State<StressScaleQuiz> {
  bool _isLoading = false;
  bool _predictionDone = false;
  double confidence = 33.01;
  final List<String> questions = [
    "In the last month, how often have you been upset because of something that happened unexpectedly?",
    "In the last month, how often have you felt that you were unable to control the important things in your life?",
    "In the last month, how often have you felt nervous and stressed?",
    "In the last month, how often have you felt confident about your ability to handle your personal problems?",
    "In the last month, how often have you felt that things were going your way?",
    "In the last month, how often have you found that you could not cope with all the things that you had to do?",
    "In the last month, how often have you been able to control irritations in your life?",
    "In the last month, how often have you felt that you were on top of things?",
    "In the last month, how often have you been angered because of things that happened that were outside of your control?",
    "In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?",
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar( // Fixed Context to context
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }




  List<int?> answers = List.filled(10, null);
  int _currentQuestionIndex = 0;
  bool _showResults = false;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    setState(() {
      answers[_currentQuestionIndex] = score;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _calculateScore() {
    int total = 0;
    for (int i = 0; i < answers.length; i++) {
      int score = answers[i] ?? 0;
      // Reverse scores for questions 4, 5, 7, 8 (0-indexed 3,4,6,7)
      if ([3, 4, 6, 7].contains(i)) {
        total += (4 - score);
      } else {
        total += score;
      }
    }
    setState(() {
      _totalScore = total;
      _showResults = true;
    });
  }

  String _getStressLevel() {
    print("((_totalScore/40*100) + confidence)/2 :----------   ${((_totalScore/40*100) + confidence)/2}");
    if (((_totalScore/40*100) + confidence)/2 <= 25) return 'Low Stress';
    if (((_totalScore/40*100) + confidence)/2 <= 50) return 'Moderate Stress';
    if (((_totalScore/40*100) + confidence)/2 <= 75) return 'Severe Stress';
    return 'Critical Stress';
  }

  Widget _buildQuestion(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (index + 1) / questions.length,
            backgroundColor: Colors.green[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
          ),
          SizedBox(height: 20),

          // Question number
          Text(
            'Question ${index + 1}',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),

          // Question text
          Text(
            questions[index],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          SizedBox(height: 25),

          // Options
          Column(
            children: [
              for (int i = 0; i <= 4; i++)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () => _answerQuestion(i),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: answers[index] == i
                            ? Colors.green[50]
                            : Colors.grey[50],
                        border: Border.all(
                          color: answers[index] == i
                              ? Colors.green[700]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: answers[index] == i
                                  ? Colors.green[700]
                                  : Colors.white,
                              border: Border.all(
                                color: answers[index] == i
                                    ? Colors.green[700]!
                                    : Colors.grey[400]!,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$i',
                              style: TextStyle(
                                fontSize: 16,
                                color: answers[index] == i
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            i == 0 ? 'Never' :
                            i == 1 ? 'Almost Never' :
                            i == 2 ? 'Sometimes' :
                            i == 3 ? 'Fairly Often' :
                            'Very Often',
                            style: TextStyle(
                              fontSize: 15,
                              color: answers[index] == i
                                  ? Colors.green[700]
                                  : Colors.grey[800],
                              fontWeight: answers[index] == i
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (!_predictionDone) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 35,
                        color: Colors.green[700],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your PSS Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '$_totalScore',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'out of 40',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.next_plan,
                            color: Colors.green[700],
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Next Steps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      _buildNextStepItem(
                        Icons.remove_red_eye,
                        'Eye Movement Analysis',
                        'Click "Analyze Stress Level" to process your eye movement data',
                      ),
                      SizedBox(height: 12),
                      _buildNextStepItem(
                        Icons.analytics,
                        'Comprehensive Assessment',
                        'Get a combined analysis of your PSS score and eye movements',
                      ),
                      SizedBox(height: 12),
                      _buildNextStepItem(
                        Icons.tips_and_updates,
                        'Personalized Insights',
                        'Receive tailored recommendations based on your results',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: _isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.analytics, size: 24),
                        label: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Analyze Stress Level',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: _isLoading ? null : () async {
                          setState(() => _isLoading = true);
                          try {
                            final request = http.MultipartRequest(
                              'POST',
                              Uri.parse('${AppConstants.BASE_URL_EYE_ANALYSIS}predict'),
                            );

                            final videoFile = await http.MultipartFile.fromPath(
                              'video',
                              widget.videoFile.path,
                            );
                            request.files.add(videoFile);

                            final response = await request.send();
                            final responseBody = await response.stream.bytesToString();


                            print("-----------------" + responseBody);


                            if (response.statusCode == 200) {
                              final Map<dynamic, dynamic> parsedData = jsonDecode(responseBody);
                              setState(() => confidence = parsedData["predicted_percentage"]);
                              setState(() => _predictionDone = true);

                            } else {
                              _showError('Analysis failed: ${response.reasonPhrase}');
                            }
                          } catch (e) {
                            _showError('Connection error: $e');
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show final results after analysis
    String stressLevel = _getStressLevel();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Your Stress Level',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      stressLevel,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: stressLevel == 'Low Stress'
                            ? Colors.green
                            : stressLevel == 'Moderate Stress'
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 15),
                    ...(_getRecommendations(stressLevel)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                'Return to Main Page',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Disclaimer: This self-assessment does not reflect any particular diagnosis or course of treatment. '
                  'It is meant as a tool to help assess your stress level. If you have concerns about your well-being, '
                  'please consult a professional.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getRecommendations(String stressLevel) {
    Map<String, String> mandalaRecommendation = {};
    Map<String, String> musicRecommendation = {};

    switch (stressLevel) {
      case 'Low Stress':
        mandalaRecommendation = {
          'level': 'Simple',
          'description': 'For your low stress level, we recommend starting with Simple mandala patterns. These basic designs will help maintain your peaceful state of mind.'
        };
        musicRecommendation = {
          'category': 'Nature Sounds with Soft Piano & Lo-Fi chill beats',
          'description': 'Gentle nature sounds combined with soft piano or relaxing lo-fi beats can help maintain your calm state.'
        };
        break;
      case 'Moderate Stress':
        mandalaRecommendation = {
          'level': 'Medium',
          'description': 'For moderate stress levels, try our Medium difficulty mandalas. These balanced patterns will help you focus and reduce stress.'
        };
        musicRecommendation = {
          'category': 'Alpha Waves & Soft Instrumental',
          'description': 'Alpha waves and soft instrumental can help balance your mood and reduce stress levels.'
        };
        break;
      case 'Severe Stress':
        mandalaRecommendation = {
          'level': 'Complex',
          'description': 'For severe stress, we recommend engaging with Complex mandala patterns. These intricate designs will help redirect your focus and provide a challenging creative outlet.'
        };
        musicRecommendation = {
          'category': 'Ambient Meditation Music & Tibetan Bowls',
          'description': 'Ambient meditation music and Tibetan singing bowls can help calm your mind and reduce severe stress symptoms.'
        };
        break;
      case 'Critical Stress':
        mandalaRecommendation = {
          'level': 'Complex',
          'description': 'For critical stress levels, try our Complex mandala patterns. These detailed designs will help you immerse yourself in creative focus.'
        };
        musicRecommendation = {
          'category': 'Gregorian Chants or OM Mantra Meditation & Deep Sleep Music',
          'description': 'Gregorian chants and deep sleep music can help restore balance and reduce anxiety.'
        };
        break;
    }

    return [
      // Mandala Recommendations
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: Colors.green[700], size: 24),
                SizedBox(width: 8),
                Text(
                  'Recommended Mandala Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${mandalaRecommendation['level']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    mandalaRecommendation['description']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Music Recommendations
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.music_note, color: Colors.green[700], size: 24),
                SizedBox(width: 8),
                Text(
                  'Recommended Music Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${musicRecommendation['category']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    musicRecommendation['description']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  String _getScoreCategory() {
    if (_totalScore <= 13) return 'Low Stress';
    if (_totalScore <= 26) return 'Moderate Stress';
    if (_totalScore <= 34) return 'Severe Stress';
    return 'Critical Stress';
  }

  Widget _buildNextStepItem(IconData icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.green[700],
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_showResults
            ? Row(
          children: [
            Icon(Icons.psychology, size: 24),
            SizedBox(width: 8),
            Text('Stress Assessment'),
          ],
        )
            : Text('Results'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _showResults
                ? _buildResults(context)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildQuestion(_currentQuestionIndex)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      ElevatedButton.icon(
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[700]!),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    ElevatedButton.icon(
                      onPressed: answers[_currentQuestionIndex] != null
                          ? (_currentQuestionIndex < questions.length - 1
                          ? _nextQuestion
                          : _calculateScore)
                          : null,
                      icon: Icon(
                        _currentQuestionIndex == questions.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentQuestionIndex == questions.length - 1
                            ? 'Finish'
                            : 'Next',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}