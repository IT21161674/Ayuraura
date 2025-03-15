import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stress_management/constants/constants.dart';
import 'package:stress_management/pages/main_pages/mandala_page/prediction_stress_mandala_and_music.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class PredictionAndHistory extends StatefulWidget {
  @override
  _PredictionAndHistoryState createState() => _PredictionAndHistoryState();
}

class _PredictionAndHistoryState extends State<PredictionAndHistory> {
  bool _isLoading = false;

  int stressLevel = 0;
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

      // Check if the document exists and has a `createdAt` field
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
        print("No sufficient data to predict stress.");
        return;
      }

      var listeningData =
          listeningSnapshot.docs.first.data() as Map<String, dynamic>;
      var coloringData =
          coloringSnapshot.docs.first.data() as Map<String, dynamic>;
      print(
          "listeningData['music_type'].split(' ')[0] : ${listeningData['track_title'].split(' ')[0]}");

      final url =
          Uri.parse("${AppConstants.BASE_URL_MANDALA_MUSIC}predict_stress");
      final payload = {
        "Age": userData["age"],
        "Gender": userData["gender"],
        "Mandala Design Pattern":
            getComplexityValue(coloringData['image_type']),
        "Mandala Colors Used": coloringData['color_palette_id'],
        "Mandala Time Spent": coloringData['color_duration'],
        "Music Type":
            getMusicTypeValue(listeningData['track_title'].split(" ")[0]),
        "Music Time Spent": listeningData['time_listened'],
        "Total_Time":
            coloringData['color_duration'] + listeningData['time_listened']
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
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
                  'Prediction Stress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _isLoading ? null : predictStress(),
                  style: ElevatedButton.styleFrom(
                    primary: _isLoading ? AppColors.primary : AppColors.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Predict Stress',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                SizedBox(height: 40),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('listening_logs')
                      .orderBy('time_listened', descending: true)
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    if (snapshot.data!.docs.isEmpty)
                      return Text("No most played track.");
                    var track = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    return Card(
                      color: Colors.blueGrey,
                      child: ListTile(
                        title: Text(track['track_title'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            "Listened for ${track['time_listened']} seconds",
                            style: TextStyle(color: Colors.white70)),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('coloring_logs')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    if (snapshot.data!.docs.isEmpty)
                      return Text("No coloring logs.");
                    var coloringLog = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    return Card(
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text(coloringLog['image_name'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            "Colored for ${coloringLog['color_duration']} seconds",
                            style: TextStyle(color: Colors.white70)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
