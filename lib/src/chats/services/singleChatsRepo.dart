import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:get/get.dart';

class SingleChatsRepo {
  final _firebaseDB = FirebaseDatabase.instance;

  DatabaseReference get userReference => _firebaseDB.reference().child('user');

  UserModel get currentUser => Get.find<AuthController>().user;

  AuthController get authController => Get.find<AuthController>();

  Future<List<UserModel>> getFriendsList() async {
    List<UserModel> friends = [];
    for (final friend in authController.user.friends) {
      final friendDoc = (await userReference.child(friend.friendId).once()).value;

      final UserModel friendObject = UserModel.fromDocument(friendDoc);
      friends.add(friendObject);
    }
    return friends;
  }
}
