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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8FFF5),
              AppColors.accent.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildActivityCards(),
                  const SizedBox(height: 30),
                  _buildInsightCard(),
                  const SizedBox(height: 30),
                  _buildStressCheckButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome! 🎨',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Express yourself through art and find peace in music',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCards() {
    return Column(
      children: [
        _buildActivityCard(
          'Mandala Arts',
          'Color intricate patterns to find your inner peace',
          Icons.palette,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MandalaNavigator()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildActivityCard(
          'Music Listening',
          'Let the healing sounds calm your mind',
          Icons.music_note,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MusicNavigator()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String description, IconData icon, VoidCallback onTap) {
    final mandalaGradient = LinearGradient(
      colors: [
        Color(0xFFFFEB3B), // Yellow
        Color(0xFFFF9800), // Orange
        Color(0xFFFF5252), // Red
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: title == 'Mandala Arts' 
              ? AppColors.calmness.withOpacity(0.3)
              : AppColors.energy.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (title == 'Mandala Arts' ? AppColors.calmness : AppColors.energy).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: title == 'Mandala Arts' ? mandalaGradient : LinearGradient(
                  colors: [
                    AppColors.energy,
                    AppColors.energy.withOpacity(0.8),
                    AppColors.energy.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (title == 'Mandala Arts' ? Color(0xFFFF9800) : AppColors.energy).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: title == 'Mandala Arts'
                    ? [
                        Colors.white,
                        Color(0xFFFFF9C4), // Light yellow
                        Colors.white,
                      ]
                    : [
                        Colors.white,
                        Color(0xFFE1F5FE), // Light blue
                        Colors.white,
                      ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 36,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => title == 'Mandala Arts' 
                      ? mandalaGradient.createShader(bounds)
                      : LinearGradient(
                          colors: [AppColors.energy, AppColors.energy],
                        ).createShader(bounds),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (title == 'Mandala Arts' ? Color(0xFFFF9800) : AppColors.energy).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: title == 'Mandala Arts' ? Color(0xFFFF9800) : AppColors.energy,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressCheckButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : predictStress,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: AppColors.accent.withOpacity(0.3),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'How Stressed Am I?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF1B5E20),
            height: 1.5,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: 'Complete both activities ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'to analyze your stress level!\n',
            ),
            TextSpan(
              text: '🎨 + 🎵 = 😌',
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 4,
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
