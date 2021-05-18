import 'package:flutter/material.dart';
import 'package:friends_making/src/home/widgets/chats.dart';
import 'package:friends_making/src/home/widgets/feed.dart';
import 'package:friends_making/src/home/widgets/profile.dart';
import 'package:get/get.dart';

enum HomeScreens { Home, Chats, Profile }

class HomeController extends GetxController {
  PageController homePagesController = PageController(initialPage: 0);

  int currentpage = 0;

  HomeScreens currentScreen = HomeScreens.Home;

  List<Widget> homePages = [
    Feed(),
    Chats(),
    Profile(),
  ];

  void changePage(int page) {
    if (page == 0) {
      currentScreen = HomeScreens.Home;
    } else if (page == 1) {
      currentScreen = HomeScreens.Chats;
    } else if (page == 2) {
      currentScreen = HomeScreens.Profile;
    }
    this.currentpage = page;
    homePagesController.jumpToPage(currentpage);

    update();
  }
}
