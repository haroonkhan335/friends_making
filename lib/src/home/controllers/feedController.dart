import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/home/models/comment.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:friends_making/src/home/services/repository.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  final repo = Repository();

  int i = 0;

  bool isEditing = true;

  List<String> currentTags = [];

  List<TextSpan> body = [];

  TextEditingController bodyPostController = TextEditingController();

  TextEditingController commentController = TextEditingController();

  TextEditingController postTagsController = TextEditingController();

  Stream getFeed() {
    FirebaseDatabase.instance
        .reference()
        .child('user')
        .orderByChild('fullName')
        .onValue
        .listen((Event event) {
      print(event.snapshot.value);
    });
  }

  void finishWritingPost() {
    // currentTags = postTagsController.text.split(',');

    bodyPostController.text = bodyPostController.text.replaceAll('\n', '\n ');
    final words = bodyPostController.text.split(' ');

    for (String word in words) {
      if (word.startsWith('#')) {
        currentTags.add(word);
      }

      body.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            color: currentTags.contains(word) ? Colors.blue : Colors.black,
          ),
        ),
      );
    }

    isEditing = false;
    print('TAGS ==== $currentTags');
    update();
  }

  void toggleEditing() {
    body.clear();
    currentTags.clear();
    isEditing = true;
    update();
  }

  void post() async {
    toggleEditing();
    final body = bodyPostController.text;
    bodyPostController.clear();
    update();
    await repo.post(post: Post.createNewPost(body: body, tags: currentTags));
  }

  void likePost(Post post) {
    repo.likePost(post);
  }

  void postComment(Post post, Comment comment) {
    repo.postComment(post, comment);
  }
}
