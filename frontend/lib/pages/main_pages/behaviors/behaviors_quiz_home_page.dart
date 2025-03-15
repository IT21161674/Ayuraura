import 'package:stress_management/pages/main_pages/behaviors/behavior_quiz_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class BehaviorsQuizHomePage extends StatelessWidget {
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
              AppColors.secondary.withOpacity(0.1),
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
                  _buildInfoCard(
                    "Track your daily behaviors and discover patterns that affect your well-being. Let's create positive changes together! 🌿",
                    AppColors.secondary,
                  ),
                  const SizedBox(height: 24),
                  _buildMoodCard(),
                  const SizedBox(height: 20),
                  _buildActionButton(context),
                  const SizedBox(height: 20),
                  _buildInsightCard(),
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
          'Welcome Back! 👋',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let\'s check in on your daily behaviors and well-being',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String text, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMoodCard() {
    final behaviors = [
      {'icon': Icons.bedtime_rounded, 'label': 'Sleep', 'color': const Color(0xFF60A5FA), 'bgColor': const Color(0xFFDBEAFE)},
      {'icon': Icons.directions_run_rounded, 'label': 'Exercise', 'color': const Color(0xFF34D399), 'bgColor': const Color(0xFFD1FAE5)},
      {'icon': Icons.work_rounded, 'label': 'Work', 'color': const Color(0xFFF59E0B), 'bgColor': const Color(0xFFFEF3C7)},
      {'icon': Icons.phone_android_rounded, 'label': 'Screen Time', 'color': const Color(0xFFF87171), 'bgColor': const Color(0xFFFEE2E2)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track Your Behaviors',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monitor key aspects of your daily routine',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: behaviors.length,
            itemBuilder: (context, index) {
              final behavior = behaviors[index];
              return _buildBehaviorButton(
                icon: behavior['icon'] as IconData,
                label: behavior['label'] as String,
                color: behavior['color'] as Color,
                bgColor: behavior['bgColor'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BehaviorsQuizScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: AppColors.primary.withOpacity(0.3),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.psychology_outlined, size: 24),
          SizedBox(width: 12),
          Text(
            "Check Your Stress Risk",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                size: 20,
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              Text(
                'Daily Wellness Tip ✨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"Small changes in your daily routine can lead to significant improvements in your well-being. '
            'Take it one step at a time! 💚"',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF4B5563),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
