import 'package:flutter/material.dart';
import 'package:custos/screens/home_screen.dart';
import 'package:custos/screens/map_screen.dart';
import 'package:custos/screens/tip_screen.dart';
import 'package:custos/screens/settings_screen.dart';

class CustomisedBottomNavigationBar extends StatefulWidget {
  @override
  _CustomisedBottomNavigationBarState createState() => _CustomisedBottomNavigationBarState();

  // Get the index of every screen , and check if the screen is one of the bottom navigation bar items or not
  CustomisedBottomNavigationBar({this.index, this.isBottomNavItem});
  final int index;
  final bool isBottomNavItem;
}

class _CustomisedBottomNavigationBarState extends State<CustomisedBottomNavigationBar> {

  int currentIndex;
  bool isBottomNavItem;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    isBottomNavItem = widget.isBottomNavItem;
  }

  List<String> screens = [
    HomeScreen.id,
    MapScreen.id,
    TipScreen.id,
    SettingsScreen.id
  ];

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      //icon: Icon(FontAwesomeIcons.searchLocation),
      icon: Icon(Icons.location_on),
      title: Text('Map'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info),
      title: Text('Tips'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _items,
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;

          //Checks if the current screen is not one of the bottom navigation bar items so it can navigate to any of them with coloring index 0 at the beginning which is home
          if(isBottomNavItem == false) {
            Navigator.pushReplacementNamed(context, screens[currentIndex]);
          }
          // Checks if the current index does not equal the screen index
          // Ex: Our current index is 0 which is the home screen and we want to navigate to the tip screen which has the index of 3
          // Ex Contd: So it meets the condition and it will navigate to the tip screen and the current index will be changed to 3
          else if(currentIndex != widget.index) {
            Navigator.pushReplacementNamed(context, screens[currentIndex]);
          }
        });
      },
      type: BottomNavigationBarType.fixed,
      /*showSelectedLabels: false,
      showUnselectedLabels: false,*/
      fixedColor: Color(0xFF4682B4),
    );
  }
}
