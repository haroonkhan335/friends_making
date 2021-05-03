import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';

class SearchBar extends StatelessWidget {

TextEditingController searchController = TextEditingController();

final controller = FollowController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Get.width * 0.8,
          height: Get.height * 0.06,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search User',
              prefixIcon: Icon(Icons.search),
              
            ),
            onChanged: (text) {
              controller.visibleUsers = controller.allUsers.where((user) => user.fullName.contains(text)).toList();
              controller.update();
              print('visible users == ${controller.visibleUsers}');
              

            },
            
          ),
        ),
        ElevatedButton(
            onPressed: () {},
            child: Text('Search'),
            style: ElevatedButton.styleFrom(primary: Colors.orangeAccent)),
      ],
    );
  }
}
