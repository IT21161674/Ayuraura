import 'package:flutter/material.dart';
import 'package:stress_management/pages/main_pages/music_page/player_screen.dart';


class TracksScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  TracksScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${category['type']} Tracks')),
      body: ListView.builder(
        itemCount: category['tracks'].length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(category['tracks'][index]['title'], style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.play_arrow, color: Colors.blue),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(track: category['tracks'][index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}