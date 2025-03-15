import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:stress_management/pages/main_pages/mandala_page/mandala_page.dart';
import 'package:stress_management/pages/main_pages/settings_page/settings_page.dart';
import 'package:stress_management/providers/main_provider.dart';
import 'package:stress_management/widgets/my_app_bar/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_pages/home_page/home_page.dart';
import '../main_pages/saved_image_list/saved_image_page.dart';

class MandalaNavigator extends StatefulWidget {
  const MandalaNavigator({Key? key}) : super(key: key);

  @override
  State<MandalaNavigator> createState() => _MandalaNavigatorState();
}

class _MandalaNavigatorState extends State<MandalaNavigator> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<String> titles = ["Mandala Arts","Colored Images History"];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      context.read<MainProvider>().loadData();
      context.read<MainProvider>().getImageList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: titles[_currentIndex],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            MandalaPage(),
            SavedImagePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.art_track),
            title: Text('Arts'),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.history),
              title: Text('History'),
              activeColor: Colors.green
          ),
          // BottomNavyBarItem(
          //     icon: Icon(Icons.message),
          //     title: Text('Messages'),
          //     activeColor: Colors.pink
          // ),
          // BottomNavyBarItem(
          //     icon: Icon(Icons.settings),
          //     title: Text('Settings'),
          //     activeColor: Colors.blue
          // ),
        ],
      ),
    );
  }
}
