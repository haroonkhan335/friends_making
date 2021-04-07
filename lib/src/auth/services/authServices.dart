import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  static final realTDB = FirebaseDatabase.instance;

  final dbReference = realTDB.reference();

  DatabaseReference userReference(String uid) =>
      dbReference.child('user/' + uid);

  User get currentUser => _firebaseAuth.currentUser;

  Future<UserModel> getCurrentUser() async {
    if (currentUser == null) {
      return null;
    }

    final data = await userReference(currentUser.uid).once();

    print(data.value.runtimeType);

    return UserModel.fromDocument(
        (await userReference(currentUser.uid).once()).value);
  }

  Future<UserModel> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = await FirebaseDatabase.instance
          .reference()
          .child('user/' + currentUser.uid)
          .once();

      // print('JSON OBJECT FROM FIREBASE ==== ${user.value}');

      final appUser = UserModel.fromDocument(user.value);

      return appUser;

      // return UserModel.fromDocument(
      //     (await userReference(currentUser.uid).once()).value);
    } catch (e) {}
    return UserModel();
  }

  Future<UserModel> logOut() async {
    await _firebaseAuth.signOut();
    return null;
  }

  Future<UserModel> signUpUser(String email, String password,
      {File image, Map<String, dynamic> userData}) async {
    try {
      final signedUpUser = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      final imageLink = await uploadImage(image);
      print(imageLink);
      userData = {...userData, 'uid': signedUpUser.uid, 'image': imageLink};
      await dbReference.child('user/' + signedUpUser.uid).set(userData);

      return UserModel.fromDocument(userData);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String> uploadImage(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref('profilePictures/${currentUser.uid}');

    await storageReference.putFile(image);

    return await storageReference.getDownloadURL();
  }
}
