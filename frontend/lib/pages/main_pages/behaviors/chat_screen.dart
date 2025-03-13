import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stress_management/constants/colors.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [
    {"text": "Hello! How are you feeling today?", "options": [
      "I'm feeling great!",
      "I'm feeling okay, just neutral.",
      "I'm feeling a little stressed today."
    ]}
  ];
  bool enableTextField = false;
  bool isLoading = false;
  TextEditingController _controller = TextEditingController();

  void _handleResponse(String response) {
    setState(() {
      messages.add({"text": response, "isUser": true});

      if (response == "I'm feeling great!") {
        messages.add({
          "text": "That's wonderful to hear! Keep up the positive energy!\n\nIs there anything else you'd like to talk about, or shall we wrap up?",
          "options": [
            "Yes, let's wrap it up. Thank you!",
            "No, I still have something to talk about."
          ]
        });

      } else if (response == "I'm feeling okay, just neutral.") {
        messages.add({
          "text": "Neutral can be peaceful. Is there anything I can do to help make your day even better?\n\nIf you'd like to chat more, I'm here! Otherwise, we can wrap up.",
          "options": [
            "Yes, let's wrap it up. Thank you!",
            "No, I still have something to talk about."
          ]
        });
      } else if (response == "I'm feeling a little stressed today.") {
        messages.add({
          "text": "I hear you. Stress can sneak up on us sometimes. Would you like to talk about it?",
          "options": [
            "No, I think I’m good for now.",
            "Yes, I’d like to talk about it."
          ]
        });
      } else if (response == "Yes, I’d like to talk about it." || response == "No, I still have something to talk about.") {
        messages.add({
          "text": "Sure! What's been on your mind?",
        });
        enableTextField = true;
      }
    });
  }

  Future<void> _sendMessageToAPI(String message) async {
    setState(() {
      messages.add({"text": message, "isUser": true});
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("https://5cd4-34-143-131-3.ngrok-free.app/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"input": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        messages.add({"text": data["output"], "isUser": false});
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Mochi"),
        backgroundColor: AppColors.secondary,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            image: AssetImage("assets/bg_logo.png"), // Path to your image
            fit: BoxFit.contain, // Cover the entire screen
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12.0),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isLoading) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircularProgressIndicator(color: AppColors.secondary),
                            SizedBox(width: 10),
                            Text("Generating response...", style: TextStyle(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    );
                  }

                  final message = messages[index];
                  return Align(
                    alignment: message["isUser"] == true
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message["isUser"] == true ? AppColors.secondary : Colors.grey[800],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomLeft: message["isUser"] == true ? Radius.circular(12.0) : Radius.zero,
                          bottomRight: message["isUser"] == true ? Radius.zero : Radius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        message["text"],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (messages.last.containsKey("options"))
              Wrap(
                spacing: 8.0,
                children: (messages.last["options"] as List<String>).map((option) {
                  return ElevatedButton(
                    onPressed: () => _handleResponse(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(option, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            if (enableTextField)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors.secondary),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessageToAPI(_controller.text);
                          _controller.clear();
                        }
                      },
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}