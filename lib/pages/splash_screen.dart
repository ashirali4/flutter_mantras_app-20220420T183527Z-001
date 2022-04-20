import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/pages/bottom_nav_bar.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'images/splash_logo.png',
        height: 150,
        width: 150,
      ),
      splashIconSize: 150,
      nextScreen: BottomNavBar(),
      backgroundColor: kPurple,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      //disableNavigation: true,
    );
  }
}
