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
    followController.getFollowers();
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
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectedTab = TAB.Followers;
                                      controller.update();
                                      controller.getFollowers();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: controller.selectedTab ==
                                                    TAB.Followers
                                                ? Colors.blue
                                                : Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text('Followers'),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectedTab = TAB.Followings;
                                      controller.update();
                                      controller.getFollowings();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: controller.selectedTab ==
                                                    TAB.Followings
                                                ? Colors.blue
                                                : Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text('Followings'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          child: GetBuilder<AuthController>(
                            builder: (_) => controller.selectedTab ==
                                        TAB.Followers &&
                                    controller.followers.length == 0
                                ? Center(child: Text('No Followers'))
                                : controller.selectedTab == TAB.Followings &&
                                        controller.followings.length == 0
                                    ? Center(child: Text('No Followings'))
                                    : ListView.builder(
                                        itemCount: controller.selectedTab ==
                                                TAB.Followers
                                            ? controller.followers.length
                                            : controller.followings.length,
                                        itemBuilder: (context, index) {
                                          final user = controller.selectedTab ==
                                                  TAB.Followers
                                              ? controller.followers[index]
                                              : controller.followings[index];
                                          return ListTile(
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                child: CachedNetworkImage(
                                                  imageUrl: user.image,
                                                  imageBuilder:
                                                      (context, image) =>
                                                          Image(image: image),
                                                ),
                                              ),
                                              title: Text(user.fullName),
                                              subtitle: Text(user.email),
                                              trailing:
                                                  controller.selectedTab ==
                                                          TAB.Followings
                                                      ? Container(
                                                          width: 70,
                                                          height: 20,
                                                          child: ElevatedButton(
                                                            //To DO
                                                            onPressed: () {
                                                              followController.unFollowUser(
                                                                  currentUser:
                                                                      Get.find<
                                                                              AuthController>()
                                                                          .user,
                                                                  followingUser:
                                                                      user);
                                                            },
                                                            child: Text(
                                                              'Unfollow',
                                                              style: TextStyle(
                                                                  fontSize: 8),
                                                            ),
                                                          ))
                                                      : null);
                                        },
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
