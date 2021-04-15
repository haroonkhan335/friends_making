import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/feedController.dart';
import 'package:friends_making/src/home/models/comment.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:get/get.dart';

class Comments extends StatelessWidget {
  final controller = Get.find<FeedController>();
  final user = Get.find<AuthController>().user;

  @override
  Widget build(BuildContext context) {
    final Post post = Get.arguments;
    final commentRef = FirebaseDatabase.instance.reference().child('comments');
    return Scaffold(
        appBar: AppBar(title: Text('Comments')),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: commentRef
                        .orderByChild('postId')
                        .equalTo(post.postId)
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DataSnapshot doc = snapshot.data.snapshot;

                        print('DOC ${doc.value}');
                        print(snapshot.data.snapshot);
                      }
                      return SizedBox();
                    })),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      controller.postComment(
                          post,
                          Comment.createNewComment(
                            body: controller.commentController.text,
                            user: user,
                            postId: post.postId,
                          ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
