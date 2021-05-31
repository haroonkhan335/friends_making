import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/home/models/comment.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:friends_making/src/home/services/repository.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  final repo = Repository();

  final authController = Get.find<AuthController>();

  int i = 0;

  bool isEditing = true;

  List<String> currentTags = [];

  List<TextSpan> body = [];

  List<Post> posts = [];

  List<Post> searchedPosts = [];

  TextEditingController bodyPostController = TextEditingController();

  TextEditingController commentController = TextEditingController();

  TextEditingController postTagsController = TextEditingController();

  Stream getFeed() {
    FirebaseDatabase.instance.reference().child('user').orderByChild('fullName').onValue.listen((Event event) {
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
        print(currentTags);
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

  List<TextSpan> createhashifiedBody(String postBody) {
    List<TextSpan> postText = [];
    List<String> postTags = [];
    postBody = postBody.replaceAll('\n', '\n ');
    final words = postBody.split(' ');

    for (String word in words) {
      if (word.startsWith('#')) {
        postTags.add(word);
      }

      postText.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            color: postTags.contains(word) ? Colors.blue : Colors.black,
          ),
        ),
      );
    }
    return postText;
  }

  void toggleEditing() {
    body.clear();
    currentTags.clear();
    isEditing = true;
    update();
  }

  void searchPostWithHashtag(String searchQuery) {
    print('POST LENGTH ${posts.length}');
    for (final post in posts) {
      print(post.tags);
    }
    print(searchQuery);
    // final List<String> postsHashtags = [for (final post in posts) post.tags];
    searchedPosts = posts.where((post) => post.tags.contains(searchQuery)).toList();

    print(searchedPosts.length);
    update();
  }

  void post() async {
    final body = bodyPostController.text;
    final tags = [for (final tag in currentTags) tag];
    log('TAGS LENGTH == ${tags.length}');
    toggleEditing();
    bodyPostController.clear();
    update();
    log('CURRENT TAGS === ${tags.length}');
    await repo.post(post: Post.createNewPost(body: body, tags: tags));
  }

  void likePost(Post post) {
    repo.likePost(post);
  }

  void postComment(Post post, Comment comment) {
    repo.postComment(post, comment);
  }

  bool checkId(String postId) {
    final postIds = [for (final post in posts) post.postId];

    return postIds.contains(postId);
  }

  void getPosts() async {
    FirebaseDatabase.instance
        .reference()
        .child('user/${Get.find<AuthController>().user.uid}/posts')
        .onChildAdded
        .listen((event) async {
      final postId = event.snapshot.value;

      final post = Post.fromDocument((await FirebaseDatabase.instance.reference().child('posts/$postId').once()).value);
      if (!checkId(post.postId)) {
        posts.add(post);
        update();
      }
    });
  }

  void removePosts() async {
    FirebaseDatabase.instance
        .reference()
        .child('user/${Get.find<AuthController>().user.uid}/posts')
        .onChildRemoved
        .listen((event) async {
      final postId = event.snapshot.value;
      print("EVENT ---- Post REMOVED ${event.snapshot.value}");
      final post = Post.fromDocument((await FirebaseDatabase.instance.reference().child('posts/$postId').once()).value);
      posts.removeWhere((postFromList) => postFromList.postId == post.postId);
      List userPosts = authController.user.posts.toList();
      userPosts.removeWhere((postFromList) => postFromList == post.postId);

      log("USER POSTS === $userPosts");

      authController.user.posts = userPosts;

      update();
      authController.update();
    });
  }
}
