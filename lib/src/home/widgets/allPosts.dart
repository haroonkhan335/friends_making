import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/feedController.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  final controller = Get.find<FeedController>();

  final currentUser = Get.find<AuthController>().user;

  final postRef = FirebaseDatabase.instance.reference().child('posts');

  @override
  void initState() {
    controller.getPosts();
    controller.removePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GetBuilder<FeedController>(
      builder: (_) => ListView.builder(
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return ListTile(
            leading: Container(
              height: 60,
              width: 60,
              child: post.posterProfilePicture == null
                  ? CircleAvatar(child: Icon(Icons.account_circle_outlined))
                  : CachedNetworkImage(
                      imageUrl: post.posterProfilePicture,
                      imageBuilder: (_, image) =>
                          CircleAvatar(backgroundImage: image),
                    ),
            ),
            title: post.posterFullName == null
                ? Text('Friend')
                : Text(post.posterFullName),
            subtitle: Text(post.body),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () {
                          controller.likePost(post);
                        },
                        child: Icon(
                          Icons.favorite,
                          color: post.likes.contains(currentUser.uid)
                              ? Colors.red
                              : Colors.grey,
                        )),
                    Text('${post.likes.length}')
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(Pages.COMMENTS, arguments: post);
                        },
                        child: Icon(Icons.chat)),
                    Text('${post.comments.length}')
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
