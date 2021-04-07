import 'package:flutter/material.dart';
import 'package:friends_making/src/home/widgets/chats.dart';
import 'package:friends_making/src/home/widgets/feed.dart';
import 'package:friends_making/src/home/widgets/profile.dart';
import 'package:friends_making/src/home/widgets/usersToFollow.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  PageController homePagesController = PageController(initialPage: 0);

  int currentpage = 0;

  List<Widget> homePages = [
    Feed(),
    Chats(),
    UsersToFollow(),
    Profile(),
  ];

  void changePage(int page) {
    this.currentpage = page;
    homePagesController.jumpToPage(currentpage);

    update();
  }
}
