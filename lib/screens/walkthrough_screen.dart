import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/models/walktrhough_slider.dart';
import 'package:custos/widgets/slider_tile.dart';
import 'package:custos/screens/home_screen.dart';

Authentication auth = Authentication();

class WalkthroughScreen extends StatefulWidget {
  static String id = 'WalkthroughScreen';

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {

  SharedPreferences prefs;

  bool walkedThrough = false;

  String docId;

  List<WalkthroughSlider> slides = List<WalkthroughSlider>();

  int currentIndex = 0;

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    slides = getSlides();
  }

  void getStarted() async {
    // Set walkedThrough to true so when the user opens the app again it doesn't navigate him to the WalkThrough Screen
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('walkedThrough', true);
    });

    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }


  // Check the current page to highlight it in the horizontal bullets list
  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 8.0 : 6.0,
      width: isCurrentPage ? 8.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey.shade500 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: slides.length,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        itemBuilder: (context, index) {
          return SliderTile(
            imageAssetPath: slides[index].getImagePath(),
            title: slides[index].getTitle(),
            description: slides[index].getDescription(),
          );
        },
      ),

      // Check if it is the last slide so it changes the Skip-Next buttons to Get Started button
      bottomSheet: currentIndex != slides.length - 1 ? Container(
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                pageController.animateToPage(slides.length - 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
              },
              child: Text(
                'SKIP',
                style: TextStyle(
                  color: Colors.grey.shade700
                ),
              ),
            ),
            Row(
              children: [
                for(int i = 0; i < slides.length; i++) currentIndex == i ? pageIndexIndicator(true) : pageIndexIndicator(false),
              ],
            ),
            GestureDetector(
              onTap: () {
                pageController.animateToPage(currentIndex + 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
              },
              child: Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.grey.shade700
                ),
              ),
            ),
          ],
        ),
      ) : GestureDetector(
        onTap: getStarted,
        child: Container(
          color: Color(0xFF4682B4),
          width: double.infinity,
          height: 56.0,
          alignment: Alignment.center,
          child: Text(
            'GET STARTED',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
        ),
      ),
    );
  }
}