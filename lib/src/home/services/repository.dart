import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/models/comment.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:get/get.dart';

class Repository {
  final _firebaseAuth = FirebaseAuth.instance;
  static final realTDB = FirebaseDatabase.instance;

  final dbReference = realTDB.reference();

  DatabaseReference userReference(String uid) => dbReference.child('user/' + uid);
  DatabaseReference get users => dbReference.child('user');

  DatabaseReference get allPostRef => dbReference.child('posts');

  DatabaseReference get commentsRef => dbReference.child('comments');

  UserModel get currUser => authController.user;

  AuthController get authController => Get.find<AuthController>();

  DatabaseReference postRef(String postId) => dbReference.child('posts/' + postId);

  Future<List<UserModel>> getFollowers() async {
    List<UserModel> followers = [];

    for (final userId in currUser.followers) {
      final followerDoc = await users.child(userId).once();
      followers.add(UserModel.fromDocument(followerDoc.value));
    }

    return followers;
  }

  Future<List<UserModel>> getFollowings() async {
    List<UserModel> followings = [];

    for (final userId in currUser.followings) {
      final followerDoc = await users.child(userId).once();
      followings.add(UserModel.fromDocument(followerDoc.value));
    }

    return followings;
  }

  Future<void> followUser({UserModel followingUser, UserModel currentUser}) async {
    List<String> followings = [...currentUser.followings];
    List<String> followers = [...followingUser.followers];

    followings.add(followingUser.uid);

    followers.add(currentUser.uid);

    currUser.followings = followings;
    authController.update();

    await userReference(currentUser.uid).update({'followings': followings});

    await userReference(followingUser.uid).update({'followers': followers});
  }

  Future<void> addFriend({UserModel followingUser, UserModel currentUser}) async {
    final doc = (await userReference(currentUser.uid).child('friends/${followingUser.uid}').once()).value;

    if (doc == null) {
      List<String> followings = [...currentUser.followings];

      List<String> followers = [...followingUser.followers];

      // List<String> myfriends = [...currentUser.friends, followingUser.uid];

      // List<String> followingUserfriends = [...followingUser.friends, currentUser.uid];

      final chatId = DateTime.now().microsecondsSinceEpoch.toString();

      final friend = Friend.fromJson({
        'chatId': chatId,
        'friendId': followingUser.uid,
        'image': followingUser.image,
        'name': followingUser.fullName,
        'status': 4,
      });

      await userReference(currentUser.uid).child('friends/${followingUser.uid}').update(friend.toJson());

      await userReference(followingUser.uid).child('friends/${currentUser.uid}').update({
        'chatId': chatId,
        'friendId': currentUser.uid,
        'image': currentUser.image,
        'name': currentUser.fullName,
        'status': 4,
      });

      // currUser.friends.add(Friend.fromJson({"friendId": followingUser.uid, "chatId": chatId}));

      followings.add(followingUser.uid);

      followers.add(currentUser.uid);

      currUser.followings = followings;

      currUser.friends.add(friend);
      authController.update();

      await userReference(currentUser.uid).update({'followings': followings});

      await userReference(followingUser.uid).update({'followers': followers});
    }

    // await userReference(currentUser.uid).update({'friends': myfriends});

    // await userReference(followingUser.uid).update({'friends': followingUserfriends});
  }

//To DO
  Future<void> unFollowUser(UserModel currentUser, UserModel followingUser) async {
    List<String> followings = [...currentUser.followings];
    List<String> followers = [...followingUser.followers];

    currUser.followings = followings;
    authController.update();

    followings.remove(followingUser.uid);
    followers.remove(currentUser.uid);

    await userReference(currentUser.uid).update({'followings': followings});

    await userReference(followingUser.uid).update({'followers': followers});
  }

  Future<void> post({Post post}) async {
    try {
      await allPostRef.child(post.postId).set(post.toJson());
      await userReference(currUser.uid).child('posts').child(post.postId).set(post.toJson());
    } catch (e) {
      log('ERROR: $e === ${e.runtimeType}');
    }
  }

  /*
  posts: {
    28934792874: {
      postBody: 'lasjfklsdfj'
    }
  }
  fksljdfkls: {
    posts: {
      j428749247: {
        postBody: 'asdjfklsjfa',

      }
    }
  }
  */

  Future<void> likePost(Post post) async {
    if (post.likes.contains(currUser.uid)) {
      List likes = post.likes.toList();

      likes.remove(currUser.uid);
      await postRef(post.postId).update({
        'likes': likes,
      });
    } else {
      await postRef(post.postId).update({
        'likes': [...post.likes, currUser.uid],
      });
    }
  }

  Future<void> postComment(Post post, Comment comment) async {
    await commentsRef.child(comment.commentId).set(comment.toJson());
    await postRef(post.postId).update({
      'comments': [...post.comments, comment.commentId],
    });
  }

  Future<List<UserModel>> allUsers({int offset}) async {
    List<UserModel> allUsers = [];
    final usersFromDB = await users.limitToFirst(offset).once();

    usersFromDB.value.forEach((key, value) {
      allUsers.add(UserModel.fromDocument(value));
    });

    allUsers.removeWhere((user) => currUser.followings.contains(user.uid));

    return allUsers;
  }
}
