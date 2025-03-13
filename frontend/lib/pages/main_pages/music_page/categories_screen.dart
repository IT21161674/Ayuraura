import 'package:flutter/material.dart';
import 'package:stress_management/pages/main_pages/music_page/tracks_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      "type": "Deep Sleep Music (Delta Waves)",
      "tracks": [
        {"title": "Deep Sleep Music 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741783908/Music%20Tracks/Type%201%20-%20Deep%20Sleep%20Music%20%28Delta%20Waves%29/oldmye4o0blq1hjvtmpk.mp3"},
        {"title": "Deep Sleep Music 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741783864/Music%20Tracks/Type%201%20-%20Deep%20Sleep%20Music%20%28Delta%20Waves%29/xdqs0agovocen6j76lwy.mp3"},
        {"title": "Deep Sleep Music 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741783846/Music%20Tracks/Type%201%20-%20Deep%20Sleep%20Music%20%28Delta%20Waves%29/qep5edwcyhjhdt7bhjzg.mp3"},
        {"title": "Deep Sleep Music 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741783836/Music%20Tracks/Type%201%20-%20Deep%20Sleep%20Music%20%28Delta%20Waves%29/cjnsie4cgqf5g9mlgequ.mp3"}
      ]
    },
    {
      "type": "Gregorian Chants or OM Mantra Meditation",
      "tracks": [
        {"title": "Gregorian Chants 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796316/Music%20Tracks/Type%202%20-%20Gregorian%20Chants%20or%20OM%20Mantra%20Meditation/l1rrwnuwpk2dwvoqwuou.mp3"},
        {"title": "Gregorian Chants 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796293/Music%20Tracks/Type%202%20-%20Gregorian%20Chants%20or%20OM%20Mantra%20Meditation/ndzb5vzbtrjex6su6cqv.mp3"},
        {"title": "Gregorian Chants 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796277/Music%20Tracks/Type%202%20-%20Gregorian%20Chants%20or%20OM%20Mantra%20Meditation/wrkkcg4cyc7oo6tuslde.mp3"},
        {"title": "Gregorian Chants 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796274/Music%20Tracks/Type%202%20-%20Gregorian%20Chants%20or%20OM%20Mantra%20Meditation/riqpbh9whj0lsu2hya9s.mp3"}
      ]
    },
    {
      "type": "Tibetan Singing Bowls",
      "tracks": [
        {"title": "Tibetan Singing Bowls 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796670/Music%20Tracks/Type%203%20-%20Tibetan%20Singing%20Bowls/in0dsb2m5h9u7pcyzc3f.mp3"},
        {"title": "Tibetan Singing Bowls 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796625/Music%20Tracks/Type%203%20-%20Tibetan%20Singing%20Bowls/oqbriufpardpxgazo6yg.mp3"},
        {"title": "Tibetan Singing Bowls 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796551/Music%20Tracks/Type%203%20-%20Tibetan%20Singing%20Bowls/lzieqv1dfgeiedubmlyw.mp3"},
        {"title": "Tibetan Singing Bowls 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741796616/Music%20Tracks/Type%203%20-%20Tibetan%20Singing%20Bowls/puk3ozanvw8nuxq0at9v.mp3"}
      ]
    },
    {
      "type": "Ambient Meditation Music",
      "tracks": [
        {"title": "Ambient Meditation Music 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741841511/Music%20Tracks/Type%204%20-%20Ambient%20Meditation%20Music/rcxl6cinyywtjyo8dt3d.mp3"},
        {"title": "Ambient Meditation Music 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741841459/Music%20Tracks/Type%204%20-%20Ambient%20Meditation%20Music/vgwxudul1vhoe0sic4dt.mp3"},
        {"title": "Ambient Meditation Music 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741840731/Music%20Tracks/Type%204%20-%20Ambient%20Meditation%20Music/u9rgxil399afikkcu90o.mp3"},
        {"title": "Ambient Meditation Music 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741798310/Music%20Tracks/Type%204%20-%20Ambient%20Meditation%20Music/dzsmulqla5wglbo1u5rg.mp3"}
      ]
    },
    {
      "type": "Soft Instrumental",
      "tracks": [
        {"title": "Soft Instrumental 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741842431/Music%20Tracks/Type%205%20-%20Soft%20Instrumental/ddyvsycpeoxstgu92bpc.mp3"},
        {"title": "Soft Instrumental 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741842420/Music%20Tracks/Type%205%20-%20Soft%20Instrumental/dk5qgbmrpjlpz44jud7t.mp3"},
        {"title": "Soft Instrumental 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741842405/Music%20Tracks/Type%205%20-%20Soft%20Instrumental/tvlurxee34n6ievksotm.mp3"},
        {"title": "Soft Instrumental 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741842394/Music%20Tracks/Type%205%20-%20Soft%20Instrumental/ynpsbohjoqdzywkadyny.mp3"}
      ]
    },
    {
      "type": "Alpha Waves",
      "tracks": [
        {"title": "Alpha Waves 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844252/Music%20Tracks/Type%206%20-%20Alpha%20Waves/tmcusgci97nwpvupnvhl.mp3"},
        {"title": "Alpha Waves 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844247/Music%20Tracks/Type%206%20-%20Alpha%20Waves/xa0tkshnjn6bu31andew.mp3"},
        {"title": "Alpha Waves 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844240/Music%20Tracks/Type%206%20-%20Alpha%20Waves/wmfggp34c70usfft2iiw.mp3"},
        {"title": "Alpha Waves 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844199/Music%20Tracks/Type%206%20-%20Alpha%20Waves/x8ganvmqq27rxjrmf9kn.mp3"}
      ]
    },
    {
      "type": "Nature Sounds with Soft Piano",
      "tracks": [
        {"title": "Nature Sounds 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844618/Music%20Tracks/Type%207%20-%20Nature%20Sounds%20with%20Soft%20Piano/bxzyejdyoekwzv1qldxq.mp3"},
        {"title": "Nature Sounds 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844610/Music%20Tracks/Type%207%20-%20Nature%20Sounds%20with%20Soft%20Piano/ulgwwcf0un7rgjdtqd7j.mp3"},
        {"title": "Nature Sounds 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844607/Music%20Tracks/Type%207%20-%20Nature%20Sounds%20with%20Soft%20Piano/fjybcroxd2ngotwrsahn.mp3"},
        {"title": "Nature Sounds 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844605/Music%20Tracks/Type%207%20-%20Nature%20Sounds%20with%20Soft%20Piano/zr0atzmoteqzt5gmgmai.mp3"}
      ]
    },
    {
      "type": "LoFI chill beats",
      "tracks": [
        {"title": "Lo-Fi 1", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844872/Music%20Tracks/Type%208%20-%20%20LoFI%20chill%20beats/je5oomidcdrumawtai41.mp3"},
        {"title": "Lo-Fi 2", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844863/Music%20Tracks/Type%208%20-%20%20LoFI%20chill%20beats/le0jfo2dvkgxrem362vg.mp3"},
        {"title": "Lo-Fi 3", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844858/Music%20Tracks/Type%208%20-%20%20LoFI%20chill%20beats/leazunuspnuts5akajrh.mp3"},
        {"title": "Lo-Fi 4", "url": "https://res.cloudinary.com/dl3mpo0w3/video/upload/v1741844841/Music%20Tracks/Type%208%20-%20%20LoFI%20chill%20beats/p0lolu15dolgzwgffiuv.mp3"}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Categories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(categories[index]['type'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TracksScreen(category: categories[index]),
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