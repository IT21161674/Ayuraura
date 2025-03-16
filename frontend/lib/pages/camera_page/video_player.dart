import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:stress_management/pages/main_pages/eye_analysis/eye_stress_level_screen.dart';
import 'package:stress_management/pages/main_pages/eye_analysis/stress_scale_quiz.dart';
import 'package:video_player/video_player.dart';
import '../../constants/colors.dart';

class VideoPage extends StatefulWidget {
  final File videoFile;
  const VideoPage({super.key, required this.videoFile});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.file(widget.videoFile);
    await _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.play();
    setState(() {});
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar( // Fixed Context to context
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Analysis",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF2AAF61),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Review your recording before proceeding with the assessment",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      width: MediaQuery.of(context).size.width * _videoController.value.aspectRatio,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _videoController.value.isPlaying
                                      ? _videoController.pause()
                                      : _videoController.play();
                                });
                              },
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                                child: Center(
                                  child: Icon(
                                    _videoController.value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    size: 80.0,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StressScaleQuiz(videoFile: widget.videoFile),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2AAF61),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Continue to Assessment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}