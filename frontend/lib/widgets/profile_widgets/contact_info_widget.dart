import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactInfoCard extends StatelessWidget {
  final String email;
  final String age;
  final String address;

  const ContactInfoCard({
    super.key,
    required this.email,
    required this.age,
    required this.address,
  });

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
              Text("Contact Information",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(26, 26, 26, 1))),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactItem(
              'assets/icons/lucide_mail.svg', Colors.green, "Email", email),
          const SizedBox(height: 12),
          _buildContactItem(
              'assets/icons/lucide_phone.svg', Colors.blue, "Age", age),
          const SizedBox(height: 12),
          _buildContactItem(
              'assets/icons/lucide_pin.svg', Colors.red, "City", address),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Widget _buildContactItem(
    String iconPath, Color iconColor, String label, String value) {
  return Row(
    children: [
      CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: SvgPicture.asset(
            iconPath, // Replace with correct icon
            height: 18,
            width: 18,
            color: iconColor,
          )),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: Color.fromRGBO(100, 116, 139, 1)),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(26, 26, 26, 1),
                fontWeight: FontWeight.w500),
          )
        ],
      )
    ],
  );
}
