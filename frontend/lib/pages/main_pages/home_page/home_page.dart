import 'package:stress_management/pages/image_list_page/image_grid_list_page.dart';
import 'package:stress_management/pages/navigator_page/navigator_page.dart';
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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          automaticallyImplyLeading: false, // This hides the back button
          backgroundColor: Color(0xFF2E7D32),
          flexibleSpace: Container(
            padding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Stress Management',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 32),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ),
            ),
          ],
          // ... rest of your existing AppBar code
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildMenuButton(context, 'Mandala Arts', HomeNavigator()),
              _buildMenuButton(context, 'Quiz Page', QuizHomeScreen()),
              _buildMenuButton(context, 'Eye Analysis', EyeAnalysisHomeScreen()),
              _buildMenuButton(context, 'Behaviors Quiz', BehaviorsQuizHomePage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.green,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }
}
