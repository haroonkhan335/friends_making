import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';

class UsersToFollow extends StatefulWidget {
  @override
  _UsersToFollowState createState() => _UsersToFollowState();
}

class _UsersToFollowState extends State<UsersToFollow> {
  final followController = Get.put(FollowController());

  @override
  void initState() {
    super.initState();
    followController.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<FollowController>(
            builder: (controller) => controller.isLoading
                ? Center(
                    child: Text('Getting data ...'),
                  )
                : Expanded(
                    child: controller.usersToFollow.length == 0
                        ? Center(child: Text('No Users'))
                        : ListView.builder(
                            itemCount: controller.usersToFollow.length,
                            itemBuilder: (context, index) {
                              final user = controller.usersToFollow[index];
                              return ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    child: CachedNetworkImage(
                                      imageUrl: user.image,
                                      imageBuilder: (context, image) =>
                                          Image(image: image),
                                    ),
                                  ),
                                  title: Text(user.fullName),
                                  subtitle: Text(user.email),
                                  trailing: GetBuilder<AuthController>(
                                    builder: (con) => FlatButton(
                                      child: Text(
                                          con.user.followings.contains(user.uid)
                                              ? 'Following'
                                              : 'Follow'),
                                      onPressed:
                                          con.user.followings.contains(user.uid)
                                              ? null
                                              : () {
                                                  controller.followUser(
                                                      followingUser: user,
                                                      currentUser: con.user);
                                                },
                                    ),
                                  ));
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
