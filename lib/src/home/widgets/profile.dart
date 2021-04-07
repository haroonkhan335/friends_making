import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';

class Profile extends StatelessWidget {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final user = authController.user;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: user.image,
              imageBuilder: (_, image) => CircleAvatar(
                radius: 50,
                backgroundImage: image,
              ),
              placeholder: (context, data) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 50),
            Text(user.fullName, style: TextStyle(fontSize: 25)),
            SizedBox(height: 10),
            Text(user.email, style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
