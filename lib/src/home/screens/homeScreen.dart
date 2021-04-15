import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/homeController.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';
import 'package:friends_making/src/home/widgets/bottomNavigation.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.homePagesController,
                  itemCount: controller.homePages.length,
                  itemBuilder: (context, index) {
                    return controller.homePages[index];
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
