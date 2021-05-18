import 'package:flutter/material.dart';
import 'package:friends_making/common/appDrawer.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/homeController.dart';
import 'package:get/get.dart';
import 'package:friends_making/src/home/widgets/bottomNavigation.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
        title: GetBuilder<HomeController>(
          // id: 0,
          builder: (_) => Text(controller.currentScreen == HomeScreens.Home
              ? 'Home'
              : controller.currentScreen == HomeScreens.Chats
                  ? 'Chats'
                  : 'Profile'),
        ),
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
