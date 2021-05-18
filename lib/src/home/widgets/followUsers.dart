import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:friends_making/src/home/widgets/searchBar.dart';
import 'package:friends_making/src/profile/screens/profilescreen.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowUsers extends StatefulWidget {
  @override
  _FollowUsersState createState() => _FollowUsersState();
}

class _FollowUsersState extends State<FollowUsers> {
  final controller = Get.put(FollowController());

  @override
  void initState() {
    controller.getAllUser();
    controller.update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: GetBuilder<FollowController>(
        builder: (controller) => Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                )
              ],
            ),
            SearchBar(),
            SizedBox(height: Get.height * 0.025),
            Expanded(
              child: controller.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SmartRefresher(
                      controller: controller.refreshController,
                      onLoading: controller.refreshUsers,
                      enablePullDown: false,
                      enablePullUp: controller.offset <= controller.allUsers.length,
                      child: ListView.builder(
                          itemCount: controller.visibleUsers.length == 0
                              ? controller.allUsers.length
                              : controller.visibleUsers.length,
                          itemBuilder: (_, index) {
                            final user = controller.visibleUsers.length == 0
                                ? controller.allUsers[index]
                                : controller.visibleUsers[index];
                            return ListTile(
                              title: Text(user.fullName),
                              subtitle: Text(user.email),
                              trailing: GetBuilder<AuthController>(
                                builder: (authController) => ElevatedButton(
                                  onPressed: authController.user.followings.contains(user.uid)
                                      ? null
                                      : () {
                                          controller.followUser(
                                              followingUser: user, currentUser: controller.currentUser);
                                        },
                                  child: Text(
                                      controller.currentUser.followers.contains(user.uid) ? 'Following' : 'Follow'),
                                ),
                              ),
                              leading: Container(
                                height: 60,
                                width: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(ProfileScreen(user: user));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: user.image,
                                    imageBuilder: (context, image) => CircleAvatar(
                                      backgroundImage: image,
                                      radius: 30,
                                    ),
                                    errorWidget: (context, errorMessage, data) => CircleAvatar(
                                      child: Icon(Icons.account_circle_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
            ),
          ],
        ),
      ),
    ));
  }
}


//
// Haroon Khan

// [h, har, har ..... haroon khan]