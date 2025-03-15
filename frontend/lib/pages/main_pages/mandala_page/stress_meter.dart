import 'package:flutter/material.dart';

class StressMeter extends StatelessWidget {
  final int stressLevel; // 0: Green, 1: Yellow, 2: Orange, 3: Red

  const StressMeter({Key? key, required this.stressLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Colors.green, Colors.yellow, Colors.orange, Colors.red];
    return Column(
      children: [
        Text("Predicted Stress Level", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              width: 50,
              height: 20,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: index <= stressLevel ? colors[index] : Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        ),
      ],
    );
  }
}