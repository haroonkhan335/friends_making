import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/models/userModel.dart';

class Repository {
  final _firebaseAuth = FirebaseAuth.instance;
  static final realTDB = FirebaseDatabase.instance;

  final dbReference = realTDB.reference();

  DatabaseReference userReference(String uid) =>
      dbReference.child('user/' + uid);
  DatabaseReference get users => dbReference.child('user');

  User get currUser => _firebaseAuth.currentUser;

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
}
