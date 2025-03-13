import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListeningHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Listening History")),
        body: Center(child: Text("Please log in to view your history.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Listening History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('listening_logs')
            .where('user_id', isEqualTo: user.uid)
            .where('date_time_listened', isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 2))))
            .orderBy('date_time_listened', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No listening history in the last 2 hours."));
          }

          var history = snapshot.data!.docs;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              var data = history[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['track_title']),
                subtitle: Text("Listened: ${data['time_listened']} sec, ${data['percentage_listened'].toStringAsFixed(2)}%"),
              );
            },
          );
        },
      ),
    );
  }
}


