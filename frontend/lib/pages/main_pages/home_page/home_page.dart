import 'package:stress_management/pages/image_list_page/image_grid_list_page.dart';
import 'package:stress_management/pages/main_pages/behaviors/chat_screen.dart';
import 'package:stress_management/pages/main_pages/mandala_page/mandala_music_home_screen.dart';
import 'package:stress_management/pages/navigator_page/mandala_navigator_page.dart';
import 'package:stress_management/providers/main_provider.dart';
import 'package:stress_management/widgets/image_menu_item/image_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/profile_page.dart';
import '../behaviors/behaviors_quiz_home_page.dart';
import '../eye_analysis/eye_analysis_home_screen.dart';
import '../mandala_page/mandala_page.dart';
import '../quiz_page/quiz_home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        'Ayuraura',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.account_circle,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // First row - Evaluate Stress (full width)
                        AspectRatio(
                          aspectRatio: 2.1,  // Make it rectangular
                          child: _buildFeatureCard(
                            context,
                            'Evaluate\nStress',
                            'assets/home/check_stress.png',
                            Icons.remove_red_eye,
                            EyeAnalysisHomeScreen(),
                            [Color(0xFF00695C), Color(0xFF004D40)],
                          ),
                        ),
                        SizedBox(height: 20.0),  // Spacing between rows
                        // Second row - Mandala Arts (full width)
                        AspectRatio(
                          aspectRatio: 2.1,  // Make it rectangular
                          child: _buildFeatureCard(
                            context,
                            'Mandala Arts\n& Music',
                            'assets/home/mandala.png',
                            Icons.palette,
                            MandalaMusicHomeScreen(),
                            [Color(0xCC6A1B9A), Color(0xCC4A148C)],
                          ),
                        ),
                        SizedBox(height: 20.0),  // Spacing between rows
                        // Third row - Two smaller buttons
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,  // Keep square for smaller buttons
                                child: _buildFeatureCard(
                                  context,
                                  'Will I\nBe Stressed?',
                                  'assets/home/behavior_quiz.png',
                                  Icons.psychology,
                                  BehaviorsQuizHomePage(),
                                  [Color(0xFFE65100), Color(0xFFEF6C00)],
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),  // Spacing between buttons
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,  // Keep square for smaller buttons
                                child: _buildFeatureCard(
                                  context,
                                  'Recovery\nPrediction',
                                  'assets/home/mood_quiz.png',
                                  Icons.quiz,
                                  QuizHomeScreen(),
                                  [Color(0xFF1565C0), Color(0xFF0D47A1)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Ayuraura Research Project 24-25J-180',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // Chatbot Button
            Positioned(
              right: 20.0,
              bottom: 40.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF424242), Color(0xFF212121)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 28.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String imagePath,
      IconData icon, Widget page, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      gradientColors[0].withOpacity(0.3),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 32.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
