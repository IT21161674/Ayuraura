import 'package:flutter/material.dart';
import 'package:stress_management/pages/main_pages/behaviors/behavior_summery.dart';

class BehaviorsQuizScreen extends StatefulWidget {
  const BehaviorsQuizScreen({Key? key}) : super(key: key);

  @override
  State<BehaviorsQuizScreen> createState() => _BehaviorsQuizScreenState();
}

class _BehaviorsQuizScreenState extends State<BehaviorsQuizScreen> {
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _questions = [
    {'text': 'On average, how many hours do you sleep per night?', 'range': [3, 9], 'image': 'assets/behaviors/sleep.png'},
    {'text': 'On average, how many days per week do you exercise?', 'range': [1, 7], 'image': 'assets/behaviors/exercise.png'},
    {'text': 'On average, how many hours per week do you spend on work/study?', 'range': [0, 100], 'image': 'assets/behaviors/work.png'},
    {'text': 'On average, how many hours per day do you spend on screens?', 'range': [0, 20], 'image': 'assets/behaviors/screen.png'},
    {'text': 'How would you rate your daily social interactions?', 'range': [1, 10], 'image': 'assets/behaviors/social.png'},
    {'text': 'How would you rate the healthiness of your diet?', 'range': [1, 10], 'image': 'assets/behaviors/diet.png'},
    {'text': 'How would you rate your smoking and drinking habits?', 'range': [1, 10], 'image': 'assets/behaviors/habits.png'},
    {'text': 'On average, how many hours per week do you spend on recreational activities?', 'range': [0, 30], 'image': 'assets/behaviors/recreation.png'},
  ];

  Map<int, double?> _answers = {};  // Changed to allow null values
  bool _hasInteractedWithCurrentQuestion = false;

  @override
  void initState() {
    super.initState();
    // Set default value for exercise to 0
    _answers[1] = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions[_currentQuestionIndex];
    bool canProceed = _answers[_currentQuestionIndex] != null && _hasInteractedWithCurrentQuestion;

    return Scaffold(
      appBar: AppBar(title: Text("Question ${_currentQuestionIndex + 1}/8")),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Center(
                    child: Text(
                      question['text'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    question['image'],
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                if (_currentQuestionIndex == 1) ...[
                  Text("Select days:", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _answers[_currentQuestionIndex] = index.toDouble();
                                _hasInteractedWithCurrentQuestion = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              primary: _answers[_currentQuestionIndex] == index.toDouble()
                                  ? Colors.blue[300]
                                  : Colors.blue[900],
                            ),
                            child: Text(
                              '${index}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _answers[_currentQuestionIndex] = (index + 4).toDouble();
                                _hasInteractedWithCurrentQuestion = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              primary: _answers[_currentQuestionIndex] == (index + 4).toDouble()
                                  ? Colors.blue[300]
                                  : Colors.blue[900],
                            ),
                            child: Text(
                              '${index + 4}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    "Select a value:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      _answers[_currentQuestionIndex]?.toStringAsFixed(1) ?? "---",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _answers[_currentQuestionIndex] != null ? Colors.blue[900] : Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          question['range'][0].toString(),
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Expanded(
                          child: Slider(
                            value: _answers[_currentQuestionIndex] ?? question['range'][0].toDouble(),
                            min: question['range'][0].toDouble(),
                            max: question['range'][1].toDouble(),
                            divisions: _currentQuestionIndex == 0
                                ? (question['range'][1] - question['range'][0]) * 2
                                : question['range'][1] - question['range'][0],
                            label: _answers[_currentQuestionIndex]?.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _answers[_currentQuestionIndex] = value;
                                _hasInteractedWithCurrentQuestion = true;
                              });
                            },
                          ),
                        ),
                        Text(
                          question['range'][1].toString(),
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 20),
                if (!canProceed) ...[
                  Text(
                    "Please select a value to continue",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex--;
                            _hasInteractedWithCurrentQuestion = _answers[_currentQuestionIndex] != null;
                          });
                        },
                        child: Text("Previous"),
                      )
                    else
                      SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: canProceed ? () {
                        if (_currentQuestionIndex < _questions.length - 1) {
                          setState(() {
                            _currentQuestionIndex++;
                            _hasInteractedWithCurrentQuestion = _answers[_currentQuestionIndex] != null;
                          });
                        } else {
                          final validAnswers = Map<int, double>.from(_answers.map((key, value) => 
                            MapEntry(key, value ?? question['range'][0].toDouble())));
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BehaviorSummery(answers: validAnswers, questions: _questions),
                            ),
                          );
                        }
                      } : null,
                      child: Text(_currentQuestionIndex == _questions.length - 1 ? "Finish" : "Next"),
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