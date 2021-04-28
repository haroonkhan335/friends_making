import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  UserModel user;

  ProfileScreen({this.user});

  final followingController = Get.find<FollowController>();

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    log("USER DP === ${user.image}");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
            CachedNetworkImage(
              imageUrl: user.image,
              errorWidget: (context, error, dyn) => SizedBox(),
              imageBuilder: (context, image) =>
                  CircleAvatar(radius: 60, backgroundImage: image),
            ),
            SizedBox(height: 30),
            Text(
              '${user.fullName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${user.email}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    child: Column(
                  children: [
                    Text(
                      'Followers',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text('${user.followers.length}')
                  ],
                )),
                Container(
                    child: Column(
                  children: [
                    Text(
                      'Followings',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text('${user.followings.length}')
                  ],
                )),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  followingController.followUser(
                      followingUser: user, currentUser: authController.user);
                },
                child: GetBuilder<AuthController>(
                    builder: (con) => Text(
                        con.user.followings.contains(user.uid)
                            ? 'Following'
                            : 'Follow')),
                style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  followingController.addUserAsFriend(
                      followingUser: user, currentUser: authController.user);
                },
                child: GetBuilder<AuthController>(
                    builder: (con) => con.user.friends.contains(user.uid)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Friends'),
                              SizedBox(width: 10),
                              Icon(Icons.check_circle, color: Colors.green)
                            ],
                          )
                        : Text('Add Friend')),
                style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      height: 100,
                      color: Colors.white,
                      child: Column(children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Block'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Report User',
                              titleStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              content: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Inappropriate Posts'),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Abusive behaviour'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Report'),
                        ),
                      ]),
                    ),
                  );
                },
                child: Text('More options'),
                style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
