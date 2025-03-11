import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stress_management/pages/main_pages/eye_analysis/stress_scale_quiz.dart';
import 'package:stress_management/pages/main_pages/quiz_page/quiz_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../utils/camera_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../widgets/camera_bloc.dart';
import '../../camera_page/camera_page.dart';


class EyeAnalysisHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Eye Analysis',
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
                      builder: (context) => BlocProvider(
                        create: (context) {
                          return CameraBloc(
                            cameraUtils: CameraUtils(),
                            permissionUtils: PermissionUtils(),
                          )..add(const CameraInitialize(recordingLimit: 15));
                        },
                        child: const CameraPage(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                ),
                child: Text(
                  'Open Camera',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => StressScaleQuiz(),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                ),
                child: const Text(
                  'User Guideline',
                  style: TextStyle(fontSize: 18),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
