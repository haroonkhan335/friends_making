import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';

class SearchBar extends StatelessWidget {
  final controller = Get.find<FollowController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FollowController>(
      builder: (_) => Row(
        children: [
          Container(
            width: Get.width * 0.8,
            height: Get.height * 0.06,
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search User',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                controller.visibleUsers = controller.allUsers
                    .where((user) => user.fullName.toLowerCase().contains(text.toLowerCase()))
                    .toList();
                controller.update();
                print('visible users == ${controller.visibleUsers}');
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {}, child: Text('Search'), style: ElevatedButton.styleFrom(primary: Colors.orangeAccent)),
        ],
      ),
    );
  }
}
