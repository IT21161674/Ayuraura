import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class DailyReminder extends StatefulWidget {
  const DailyReminder({Key? key}) : super(key: key);

  @override
  State<DailyReminder> createState() => _DailyReminderState();
}

class _DailyReminderState extends State<DailyReminder> {
  TimeOfDay selectedTime = TimeOfDay.now(); // Default time

  // Function to open the TimePicker
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial, // Clock Dial Mode
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialHandColor: AppColors.secondary,
              dialBackgroundColor: Colors.grey[200],
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppColors.secondary.withOpacity(0.5),
              entryModeIconColor: AppColors.secondary,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Function to show a success alert
  void _showReminderSetAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reminder Set!'),
          content: Text(
            'Your reminder is set for ${selectedTime.format(context)}! We’ll notify you to log your emotions daily.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK', style: TextStyle(
                color: AppColors.secondary,
              ),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Stay On Track With Daily Reminders 📅",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Let us remind you to check in and feel better every day!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              // Clock View Display
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary, width: 4),
                ),
                child: Center(
                  child: Text(
                    selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickTime(context),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Edit Time',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showReminderSetAlert(context),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Set My Reminder ⏰',
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
