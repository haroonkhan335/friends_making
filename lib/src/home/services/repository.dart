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

  DatabaseReference userReference(String uid) =>
      dbReference.child('user/' + uid);
  DatabaseReference get users => dbReference.child('user');

  DatabaseReference get allPostRef => dbReference.child('posts');

  DatabaseReference get commentsRef => dbReference.child('comments');

  UserModel get currUser => Get.find<AuthController>().user;

  DatabaseReference postRef(String postId) =>
      dbReference.child('posts/' + postId);

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> usersFromDB = [];
    final data = (await users.once()).value;
    data.forEach((key, value) {
      print("VALUE: $value");
      usersFromDB.add(UserModel.fromDocument(value));
    });

    return usersFromDB;
  }

  Future<void> followUser(
      {UserModel followingUser, UserModel currentUser}) async {
    await userReference(currentUser.uid).update({
      'followings': [...currentUser.followings, followingUser.uid]
    });

    await userReference(followingUser.uid).update({
      'followers': [...followingUser.followers, currentUser.uid]
    });
  }

  Future<void> post({Post post}) async {
    await allPostRef.child(post.postId).set(post.toJson());
    await userReference(currUser.uid).update({
      'posts': [...currUser.posts, post.postId],
    });
  }

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
}
