import 'package:flutter/material.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      height: Get.height,
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.25),
          ListTile(
            onTap: () {
              Get.toNamed(Pages.FOLLOW_USERS);
            },
            leading: Icon(Icons.account_circle),
            title: Text('Follow Users'),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(Pages.USERS);
            },
            leading: Icon(Icons.account_circle),
            title: Text('Users'),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(Pages.USERS);
            },
            leading: Icon(Icons.logout),
            title: Text('Log out'),
          ),
        ],
      ),
    ));
  }
}
