import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:friends_making/src/profile/controllers/profileController.dart';
import 'package:friends_making/src/profile/widgets/profileView.dart';
import 'package:friends_making/src/profile/widgets/topBar.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {

  UserModel user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}


class _ProfileScreenState extends State<ProfileScreen> {

  final controller = Get.put(ProfileController());

  final followingController = Get.find<FollowController>();

  final authController = Get.find<AuthController>();


@override
  void initState() {
    
    
   // to do


    controller.loadPosts(widget.user.uid);
    controller.update();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    log("USER DP === ${widget.user.image}");
    print('number of posts ${controller.posts.length}');

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: Get.size.height * 0.055),
                topBar(),
                ProfileView(user: widget.user),
                SizedBox(height: 10),
               
              ],
            ),
            Column(children: [ GetBuilder<ProfileController>(
              builder: (_) => ListView.builder(
                  itemCount: controller.posts.length, 
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    return ListTile(title: Text(post.body),);

                  }),
            )])
          ],
        ),
      ),
    );
  }
}
