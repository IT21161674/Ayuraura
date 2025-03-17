import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


class EyeStressLevelScreen extends StatefulWidget {
  final String responseData;
  const EyeStressLevelScreen({Key? key, required this.responseData}) : super(key: key);

  @override
  State<EyeStressLevelScreen> createState() => _EyeStressLevelScreenState();
}

class _EyeStressLevelScreenState extends State<EyeStressLevelScreen> {
  @override
  Widget build(BuildContext context) {
    print("-------------responseData :"+ widget.responseData);
    double confidence = 33.01;
    int predictedLevel = 3;

    return Scaffold(
      appBar: AppBar(title: Text('Stress Level Prediction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Predicted Stress Level: Level $predictedLevel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: confidence / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  Text('${confidence.toStringAsFixed(2)}%'),
                ],
              ),
              SizedBox(height: 32),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.info, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        'Your stress level is being monitored.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the main page
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Return to Main Page'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
