import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/controllers/followController.dart';
import 'package:get/get.dart';


class ProfileView extends StatefulWidget {

UserModel user;

ProfileView({this.user});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
final followingController = Get.find<FollowController>();

final authController = Get.find<AuthController>();

@override
  void initState() {
    // TODO: implement initState
    //controller.getUserPosts(widget.user.uid)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
              children: [
                SizedBox(width: Get.size.width * 0.05),
                CachedNetworkImage(
                  imageUrl: widget.user.image,
                  errorWidget: (context, error, dyn) => SizedBox(),
                  imageBuilder: (context, image) => CircleAvatar(
                      radius: Get.size.width * 0.21, backgroundImage: image),
                ),
                SizedBox(width: Get.size.width * 0.05),
                Column(
                  children: [
                    Text(
                      '${widget.user.fullName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Get.height*0.005),
                    Text(
                      '${widget.user.email}',
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
                              SizedBox(height: 2),
                              Text('${widget.user.followers.length}')
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Get.size.width * 0.035,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Followings',
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(height: 2),
                              Text('${widget.user.followings.length}')
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.size.height * 0.020),

                    SizedBox(
                      width: Get.size.width * 0.40,
                      height: Get.size.height * 0.025,
                      child: ElevatedButton(
                        onPressed: () {
                          followingController.followUser(
                              followingUser: widget.user,
                              currentUser: authController.user);
                        },
                        child: GetBuilder<AuthController>(
                            builder: (con) => Text(
                                con.user.followings.contains(widget.user.uid)
                                    ? 'Following'
                                    : 'Follow')),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: Get.size.width * 0.40,
                      height: Get.size.height * 0.025,
                      child: ElevatedButton(
                        onPressed: () {
                          followingController.addUserAsFriend(
                              followingUser: widget.user,
                              currentUser: authController.user);
                        },
                        child: GetBuilder<AuthController>(
                            builder: (con) => con.user.friends
                                    .contains(widget.user.uid)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Friends'),
                                      SizedBox(width: 10),
                                      Icon(Icons.check_circle,
                                          color: Colors.green)
                                    ],
                                  )
                                : Text('Add Friend')),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent),
                      ),
                    ),
                    SizedBox(height: 10),
                    
                    
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
    );
  }
}