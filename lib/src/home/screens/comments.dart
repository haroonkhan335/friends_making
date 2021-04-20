import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/controllers/feedController.dart';
import 'package:friends_making/src/home/models/comment.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';

class Comments extends StatelessWidget {
  final controller = Get.find<FeedController>();
  final user = Get.find<AuthController>().user;

  @override
  Widget build(BuildContext context) {
    final Post post = Get.arguments;
    log('POST ID = ${post.postId}');
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
                  List<Comment> comments = [];
                  if (snapshot.hasData) {
                    DataSnapshot doc = snapshot.data.snapshot;

                    doc.value.forEach((key, value) {
                      comments.add(Comment.fromDocument(value));
                    });
                    comments.sort((comment, nextComment) =>
                        nextComment.commentTime.compareTo(comment.commentTime));
                    return ListView.builder(
                      reverse: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: Container(
                            height: 60,
                            width: 60,
                            child: CachedNetworkImage(
                                imageUrl: comment.commenterImage,
                                imageBuilder: (_, image) => CircleAvatar(
                                      backgroundImage: image,
                                      radius: 30,
                                    )),
                          ),
                          title: Text(comment.commenterName),
                          subtitle: Text(comment.body),
                          trailing: Text(
                            timeago.format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(comment.commentTime),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
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
                      controller.commentController.clear();
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
