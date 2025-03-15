import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../main_pages/music_page/categories_screen.dart';
import '../main_pages/music_page/listening_history_screen.dart';

class MusicNavigator extends StatefulWidget {
  const MusicNavigator({Key? key}) : super(key: key);

  @override
  State<MusicNavigator> createState() => _MusicNavigatorState();
}

class _MusicNavigatorState extends State<MusicNavigator> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<String> titles = ["Music Categories", "Listening History"];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            CategoriesScreen(),
            ListeningHistoryScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.music_note),
            title: Text('Music'),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
} 