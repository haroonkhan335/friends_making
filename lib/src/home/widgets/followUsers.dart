import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';

class FollowUsers extends StatefulWidget {
  @override
  _FollowUsersState createState() => _FollowUsersState();
}

class _FollowUsersState extends State<FollowUsers> {
  final controller = Get.put(FollowController());
  @override
  void initState() {
    controller.getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<FollowController>(
      builder: (controller) => Column(
        children: [
          Expanded(
            child: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: controller.allUsers.length,
                    itemBuilder: (_, index) {
                      final user = controller.allUsers[index];
                      return ListTile(
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                        trailing: GetBuilder<AuthController>(
                          builder: (authController) => ElevatedButton(
                            onPressed: authController.user.followings
                                    .contains(user.uid)
                                ? null
                                : () {
                                    controller.followUser(
                                        followingUser: user,
                                        currentUser: controller.currentUser);
                                  },
                            child: Text(controller.currentUser.followers
                                    .contains(user.uid)
                                ? 'Following'
                                : 'Follow'),
                          ),
                        ),
                        leading: Container(
                          height: 60,
                          width: 60,
                          child: CachedNetworkImage(
                            imageUrl: user.image,
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 30,
                            ),
                            errorWidget: (context, errorMessage, data) =>
                                CircleAvatar(
                              child: Icon(Icons.account_circle_outlined),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    ));
  }
}
