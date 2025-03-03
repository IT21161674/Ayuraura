import 'package:flutter/material.dart';


class BehaviorSummery extends StatefulWidget {
  final Map<int, double> answers;
  final List<Map<String, dynamic>> questions;

  BehaviorSummery({required this.answers, required this.questions});

  @override
  State<BehaviorSummery> createState() => _BehaviorSummeryState();
}

class _BehaviorSummeryState extends State<BehaviorSummery> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.questions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.questions[index]['text']),
              subtitle: Text("Your Answer: ${widget.answers[index]?.toStringAsFixed(1)}"),
            );
          },
        ),
      ),
    );
  }
}
