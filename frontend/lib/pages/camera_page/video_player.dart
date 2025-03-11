import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:stress_management/pages/main_pages/eye_analysis/eye_stress_level_screen.dart';
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
  Widget build(BuildContext context) { // Correct context parameter here

    Future<void> _analyzeStress() async {
      setState(() => _isLoading = true);

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://91a4-175-157-12-69.ngrok-free.app/predict'),
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
          Navigator.push(
            context, // Correct context here
            MaterialPageRoute(
              builder: (context) => EyeStressLevelScreen(responseData: responseBody),
            ),
          );
        } else {
          _showError('Analysis failed: ${response.reasonPhrase}');
        }
      } catch (e) {
        _showError('Connection error: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Preview"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    icon: _isLoading
                        ? const SizedBox.shrink()
                        : const Icon(Icons.analytics, size: 24),
                    label: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Analyze Stress Level'),
                    onPressed: _isLoading ? null : _analyzeStress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}