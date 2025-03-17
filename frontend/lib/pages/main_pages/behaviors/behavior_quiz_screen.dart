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
    {
      'text': 'How would you rate your daily social interactions?',
      'range': [1, 10],
      'image': 'assets/behaviors/social.png',
      'rangeLabels': {'start': 'Poor social life', 'end': 'Excellent social life'}
    },
    {
      'text': 'How would you rate the healthiness of your diet?',
      'range': [1, 10],
      'image': 'assets/behaviors/diet.png',
      'rangeLabels': {'start': 'Very unhealthy', 'end': 'Very healthy'}
    },
    {
      'text': 'How would you rate your smoking and drinking habits?',
      'range': [1, 10],
      'image': 'assets/behaviors/habits.png',
      'rangeLabels': {'start': 'Healthy habits', 'end': 'Concerning habits'}
    },
    {'text': 'On average, how many hours per week do you spend on recreational activities?', 'range': [0, 30], 'image': 'assets/behaviors/recreation.png'},
  ];

  Map<int, double?> _answers = {};  // Changed to allow null values
  bool _hasInteractedWithCurrentQuestion = false;

  @override
  void initState() {
    super.initState();
    // Removed default value for exercise
  }

  String? _getRangeLabel(int index, bool isStart) {
    final question = _questions[index];
    if (question.containsKey('rangeLabels')) {
      return isStart ? question['rangeLabels']['start'] : question['rangeLabels']['end'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions[_currentQuestionIndex];
    bool canProceed = _answers[_currentQuestionIndex] != null && _hasInteractedWithCurrentQuestion;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.white],
            stops: [0.15, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${_currentQuestionIndex + 1}/${_questions.length}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.blue[100],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                minHeight: 6,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  child: Center(
                                    child: Text(
                                      question['text'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.28,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      question['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        if (_currentQuestionIndex == 1) ...[
                          Text(
                            "Select days:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _answers[_currentQuestionIndex] = index.toDouble();
                                        _hasInteractedWithCurrentQuestion = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                      primary: _answers[_currentQuestionIndex] == index.toDouble()
                                          ? Colors.blue[700]
                                          : Colors.blue[100],
                                      elevation: _answers[_currentQuestionIndex] == index.toDouble() ? 8 : 2,
                                    ),
                                    child: Text(
                                      '$index',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _answers[_currentQuestionIndex] == index.toDouble()
                                            ? Colors.white
                                            : Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _answers[_currentQuestionIndex] = (index + 4).toDouble();
                                        _hasInteractedWithCurrentQuestion = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                      primary: _answers[_currentQuestionIndex] == (index + 4).toDouble()
                                          ? Colors.blue[700]
                                          : Colors.blue[100],
                                      elevation: _answers[_currentQuestionIndex] == (index + 4).toDouble() ? 8 : 2,
                                    ),
                                    child: Text(
                                      '${index + 4}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _answers[_currentQuestionIndex] == (index + 4).toDouble()
                                            ? Colors.white
                                            : Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ] else ...[
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Select a value:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _answers[_currentQuestionIndex]?.toStringAsFixed(1) ?? "---",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: _answers[_currentQuestionIndex] != null
                                            ? Colors.blue[900]
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  question['range'][0].toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                                if (_getRangeLabel(_currentQuestionIndex, true) != null)
                                                  Text(
                                                    _getRangeLabel(_currentQuestionIndex, true)!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  question['range'][1].toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                                if (_getRangeLabel(_currentQuestionIndex, false) != null)
                                                  Text(
                                                    _getRangeLabel(_currentQuestionIndex, false)!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      SliderTheme(
                                        data: SliderThemeData(
                                          activeTrackColor: Colors.blue[700],
                                          inactiveTrackColor: Colors.blue[100],
                                          thumbColor: Colors.blue[900],
                                          overlayColor: Colors.blue.withOpacity(0.2),
                                          trackHeight: 6,
                                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                                          overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                                        ),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 12),
                        if (!canProceed) ...[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: Colors.red[400], size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Please select a value to continue",
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentQuestionIndex > 0)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _currentQuestionIndex--;
                                    _hasInteractedWithCurrentQuestion = _answers[_currentQuestionIndex] != null;
                                  });
                                },
                                icon: Icon(Icons.arrow_back),
                                label: Text("Previous"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[200],
                                  onPrimary: Colors.blue[900],
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                            else
                              SizedBox.shrink(),
                            ElevatedButton.icon(
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
                              icon: Icon(_currentQuestionIndex == _questions.length - 1 ? Icons.check : Icons.arrow_forward),
                              label: Text(_currentQuestionIndex == _questions.length - 1 ? "Finish" : "Next"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[700],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
            ],
          ),
        ),
      ),
    );
  }
}