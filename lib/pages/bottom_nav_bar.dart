import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/pages/home_screen.dart';
import 'package:flutter_mantras_app/pages/notification_screen.dart';
import 'package:flutter_mantras_app/pages/recording_screen.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavBar extends StatelessWidget {

  BottomNavBar({Key? key}) : super(key: key);

  final PersistentTabController _controller= PersistentTabController(initialIndex: 0);
  late double widthScale;
  late double heightScale;

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const RecordingsScreen(),
      const NotificationScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset('images/icons/session.png',width:22*widthScale ,height:22*widthScale,color: kPurple,),
        inactiveIcon: Image.asset('images/icons/session.png',width:22*widthScale ,height:22*widthScale,color: CupertinoColors.systemGrey,),
        title: ("Sessions"),
        activeColorPrimary: kPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('images/icons/record.png',width:22*widthScale ,height:22*widthScale,color: kPurple,),
        inactiveIcon: Image.asset('images/icons/record.png',width:22*widthScale ,height:22*widthScale,color: CupertinoColors.systemGrey,),
        title: ("Recordings"),
        activeColorPrimary: kPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('images/icons/notification.png',width:22*widthScale ,height:22*widthScale,color: kPurple,),
        inactiveIcon: Image.asset('images/icons/notification.png',width:22*widthScale ,height:22*widthScale,color: CupertinoColors.systemGrey,),
        title: ("Notifications"),
        activeColorPrimary: kPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      navBarHeight: 70*heightScale,
      backgroundColor: kWhite, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        //borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,boxShadow: [
        BoxShadow(
            color: Color(0x18000000),
            offset: Offset(0, 4),
            blurRadius: 18,
            spreadRadius: 0)
      ]
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
