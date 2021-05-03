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
import 'package:timeago/timeago.dart' as timeago;

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
    log("USER ID === ${widget.user.uid}");
    print('number of posts ${controller.posts.length}');
    print('posts from profile screen: ${controller.posts}');

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(),
            SizedBox(height: Get.size.height * 0.055),
            TopBar(),
            ProfileView(user: widget.user),
            SizedBox(height: 10),
            Expanded(
              child: GetBuilder<ProfileController>(
                builder: (_) => ListView.builder(
                    itemCount: controller.posts.length,
                    itemBuilder: (context, index) {
                      final post = controller.posts[index];
                      return ListTile(
                          leading: Container(
                            height: 60,
                            width: 60,
                            child: CachedNetworkImage(
                                imageUrl: post.posterProfilePicture,
                                imageBuilder: (_, image) => CircleAvatar(
                                      backgroundImage: image,
                                      radius: 30,
                                    )),
                          ),
                          title: Text(post.posterFullName),
                          subtitle: Text(post.body),
                          trailing: Text(
                            timeago.format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(post.postTime),
                              ),
                            ),
                          ),
                        );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}



