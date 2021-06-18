import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/utils/notificationService.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  static final realTDB = FirebaseDatabase.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  final dbReference = realTDB.reference();

  DatabaseReference userReference(String uid) => dbReference.child('user/' + uid);

  User get currentUser => _firebaseAuth.currentUser;

  Future<UserModel> getCurrentUser() async {
    if (currentUser == null) {
      return null;
    }

    final data = await userReference(currentUser.uid).once();

    print(data.value.runtimeType);

    return UserModel.fromDocument((await userReference(currentUser.uid).once()).value);
  }

  Future<UserModel> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      final user = await FirebaseDatabase.instance.reference().child('user/' + currentUser.uid).once();

      // print('JSON OBJECT FROM FIREBASE ==== ${user.value}');

      final appUser = UserModel.fromDocument(user.value);
      await FirebaseDatabase.instance
          .reference()
          .child('user/' + currentUser.uid)
          .update({"pushToken": await NotificationService.getPushToken()});
      return appUser;

      // return UserModel.fromDocument(
      //     (await userReference(currentUser.uid).once()).value);
    } catch (e) {
      Get.snackbar('Error logging in', '$e');
      return null;
    }
  }

  Future<void> refreshToken(String token) async {
    await userReference(currentUser.uid).update({"pushToken": token});
  }

  Future<UserModel> logOut() async {
    await _firebaseAuth.signOut();
    return null;
  }

  Future<UserModel> signUpUser(String email, String password, {File image, Map<String, dynamic> userData}) async {
    try {
      final signedUpUser = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

      final imageLink = await uploadImage(image);
      print(imageLink);

      userData = {
        ...userData,
        'uid': signedUpUser.uid,
        'image': imageLink,
        "pushToken": await NotificationService.getPushToken()
      };
      await dbReference.child('user/' + signedUpUser.uid).set(userData);

      return UserModel.fromDocument(userData);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<String> uploadImage(File image) async {
    final storageReference = FirebaseStorage.instance.ref('profilePictures/${currentUser.uid}');

    await storageReference.putFile(image);

    return await storageReference.getDownloadURL();
  }

  Future<UserModel> signInWithGoogle(AuthController controller) async {
    try {
      // hold the instance of the authenticated user
      User user;
      // flag to check whether we're signed in already

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      AuthCredential credential =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _firebaseAuth.signInWithCredential(credential)).user;

      final userInDatabase = await _firestore.collection('users').doc(user.uid).get();

      //if user exists in database return existing data
      if (userInDatabase.exists) {
        Map<String, dynamic> userD = {
          // "city": city,
          "directions": directions,
          "latitude": latitude,
          "longitude": longitude,
          "cityCode": city,
          "lastLoginAt": DateTime.now()
        };
        await userInDatabase.reference.set(userD, SetOptions(merge: true));
        return UserModel.User.fromJson({...userInDatabase.data(), ...userD});
      }

      final fullName = user.displayName.split(" ");
      final firstName = fullName[0] ?? "";
      final lastName = fullName[1] ?? "";
      final middleInitial = "${firstName[0].toUpperCase() ?? ""}${lastName[0] ?? ""}";

      final userModel = UserModel(
          uid: user.uid,
          fullName: firstName + lastName,
          pushToken: await NotificationService.getPushToken(),
          email: user.email,
          image: user.photoURL);
      await realTDB.reference().child('user/${userModel.uid}').set(userModel.toJson());
      return userModel;
    } catch (error) {
      print("Error Signing in: $error");
      Fluttertoast.showToast(
        timeInSecForIosWeb: 5,
        msg: error.toString(),
      );
    }
  }
}
