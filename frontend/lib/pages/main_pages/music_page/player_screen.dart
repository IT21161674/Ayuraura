import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final Map<String, String> track;

  PlayerScreen({required this.track});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? totalDuration;
  Duration listenedDuration = Duration.zero;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setUrl(widget.track['url']!).then((_) {
      setState(() {
        totalDuration = _audioPlayer.duration;
      });
    });
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        listenedDuration = position;
      });
    });
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      setState(() {
        isPlaying = false;
      });

      await _audioPlayer.pause();
    } else {
      setState(() {
        isPlaying = true;
      });
      startTime = DateTime.now();
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _submitListeningData() async {
    if (startTime == null || totalDuration == null) return;
    final percentageListened = (listenedDuration.inSeconds / totalDuration!.inSeconds) * 100;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance.collection('listening_logs').add({
        'user_id': user.uid,
        'track_title': widget.track['title'],
        'date_time_listened': startTime,
        'time_listened': listenedDuration.inSeconds,
        'percentage_listened': percentageListened,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listening data submitted!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.track['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Playing ${widget.track['title']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            StreamBuilder<Duration?> (
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final duration = _audioPlayer.duration?.inSeconds ?? 1;
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: snapshot.hasData && duration > 0 ? snapshot.data!.inSeconds / duration : 0.0,
                      backgroundColor: Colors.grey,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(snapshot.hasData ? "${snapshot.data!.inMinutes}:${(snapshot.data!.inSeconds % 60).toString().padLeft(2, '0')}" : "0:00")
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePlayPause,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitListeningData,
              child: Text("Submit Listening Data"),
            ),
          ],
        ),
      ),
    );
  }
}

