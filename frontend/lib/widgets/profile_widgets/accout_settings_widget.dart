import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';

class AccountSettingsCard extends StatefulWidget {
  const AccountSettingsCard({super.key});

  @override
  _AccountSettingsCardState createState() => _AccountSettingsCardState();
}

class _AccountSettingsCardState extends State<AccountSettingsCard> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Account Settings",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(26, 26, 26, 1))),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchItem("Push Notifications", 'assets/icons/lucide_bell.svg',
              notificationsEnabled, (val) {
            setState(() {
              notificationsEnabled = val;
            });
          }),
          _buildSwitchItem("Location Services", 'assets/icons/lucide_pin.svg',
              locationEnabled, (val) {
            setState(() {
              locationEnabled = val;
            });
          }),
          _buildSwitchItem("Analytics", 'assets/icons/lucide_circle_help.svg',
              analyticsEnabled, (val) {
            setState(() {
              analyticsEnabled = val;
            });
          }),
        ],
      ),
    );
  }
}

Widget _buildSwitchItem(
    String title, String iconPath, bool value, Function(bool) onChanged) {
  return Row(
    children: [
      SvgPicture.asset(
        iconPath,
        height: 18,
        width: 18,
        color: Color.fromRGBO(100, 116, 139, 1),
      ),
      const SizedBox(width: 12),
      Text(
        title,
        style: TextStyle(fontSize: 14, color: Color.fromRGBO(26, 26, 26, 1)),
      ),
      Spacer(),
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green.shade600,
      )
    ],
  );
}
