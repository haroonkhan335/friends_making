import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/homeController.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) => BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedIconTheme: IconThemeData(color: Colors.blue),
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 17),
        unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 17),
        onTap: (int i) {
          print(i);
          homeController.changePage(i);
        },
        currentIndex: homeController
            .currentpage, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_sharp),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
