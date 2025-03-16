import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({
    super.key,
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
              Text('Support & Help',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(26, 26, 26, 1))),
            ],
          ),
          const SizedBox(height: 16),
          _buildRowItem("Help Center", 'assets/icons/lucide_circle_help.svg',
              false, (val) {}),
          SizedBox(
            height: 12,
          ),
          _buildRowItem(
              "Contact Support", 'assets/icons/user.svg', false, (val) {}),
          SizedBox(
            height: 12,
          ),
          _buildRowItem("Help Center", 'assets/icons/material_privacy.svg',
              false, (val) {}),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

Widget _buildRowItem(
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
    ],
  );
}
