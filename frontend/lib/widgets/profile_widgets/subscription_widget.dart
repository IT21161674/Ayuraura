import 'package:flutter/material.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String currentPlan;
  final bool active;
  final String renewalDate;
  final String plan;
  final VoidCallback onTap;
  final String description;

  const SubscriptionPlanCard(
      {super.key,
      required this.currentPlan,
      required this.active,
      required this.renewalDate,
      required this.plan,
      required this.onTap,
      required this.description});

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
              Text(currentPlan,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(26, 26, 26, 1))),
              const Spacer(),
              if (active)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: Text(
                    "Active",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color:Color(0xff64748b)
            ),
          ),

          const SizedBox(height: 12),

          /// Subscription Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xfff8fafc),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Renewal Date", renewalDate),
                const SizedBox(height: 8),
                _buildDetailRow("Plan", plan),
              ],
            ),
          ),
          const SizedBox(height: 16),

          /// Manage Subscription Button
          SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Manage Subscription",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
       color: Colors.grey,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    ],
  );
}
