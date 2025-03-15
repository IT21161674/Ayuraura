import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stress_management/pages/main_pages/eye_analysis/stress_scale_quiz.dart';
import 'package:stress_management/pages/main_pages/mandala_page/prediction_stress_mandala_and_music.dart';
import 'package:stress_management/pages/navigator_page/music_navigator_page.dart';
import 'package:stress_management/pages/main_pages/quiz_page/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../utils/camera_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../widgets/camera_bloc.dart';
import '../../camera_page/camera_page.dart';
import '../../navigator_page/mandala_navigator_page.dart';

class MandalaMusicHomeScreen extends StatefulWidget {
  @override
  _MandalaMusicHomeScreenState createState() => _MandalaMusicHomeScreenState();
}

class _MandalaMusicHomeScreenState extends State<MandalaMusicHomeScreen> {
  bool _isLoading = false;
  Map<String, dynamic> userData = <String, dynamic>{};

  String getComplexityValue(String type) {
    switch (type.toLowerCase()) {
      case 'simple':
        return "3 (Simple)";
      case 'medium':
        return "2 (Medium)";
      case 'complex':
        return "1 (Complex)";
      default:
        return "1 (Complex)";
    }
  }

  int getMusicTypeValue(String type) {
    switch (type.toLowerCase()) {
      case 'Deep':
        return 1;
      case 'Gregorian':
        return 2;
      case 'Tibetan':
        return 3;
      case 'Ambient':
        return 4;
      case 'Soft':
        return 5;
      case 'Alpha':
        return 6;
      case 'Nature':
        return 7;
      case 'LoFI':
        return 8;
      default:
        return 1;
    }
  }

  Future<void> predictStress() async {
    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently logged in.");
        return null;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        userData = userDoc.data() as Map<String, dynamic>;
      }

      final listeningSnapshot = await FirebaseFirestore.instance
          .collection('listening_logs')
          .orderBy('time_listened', descending: true)
          .limit(1)
          .get();

      final coloringSnapshot = await FirebaseFirestore.instance
          .collection('coloring_logs')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (listeningSnapshot.docs.isEmpty || coloringSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please complete both coloring and listening activities first.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      var listeningData = listeningSnapshot.docs.first.data() as Map<String, dynamic>;
      var coloringData = coloringSnapshot.docs.first.data() as Map<String, dynamic>;

      final url = Uri.parse("${AppConstants.BASE_URL_MANDALA_MUSIC}predict_stress");
      final payload = {
        "Age": userData["age"],
        "Gender": userData["gender"],
        "Mandala Design Pattern": getComplexityValue(coloringData['image_type']),
        "Mandala Colors Used": coloringData['color_palette_id'],
        "Mandala Time Spent": coloringData['color_duration'],
        "Music Type": getMusicTypeValue(listeningData['track_title'].split(" ")[0]),
        "Music Time Spent": listeningData['time_listened'],
        "Total_Time": coloringData['color_duration'] + listeningData['time_listened']
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _isLoading = false);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PredictionStressMandalaAndMusic(
                stressLevel: data["Stress Level"]),
          ),
        );
      }
    } catch (e) {
      print("Error predicting stress: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error predicting stress. Please try again.')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.1,
            image: AssetImage("assets/bg_logo.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mandala Arts & Music',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MandalaNavigator(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    'Mandala Arts',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MusicNavigator(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    'Music Listening',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : predictStress,
                  style: ElevatedButton.styleFrom(
                    primary: _isLoading ? AppColors.primary : AppColors.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text(
                          'How Stressed Am I?',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
