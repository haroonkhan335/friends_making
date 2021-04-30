import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:get/get.dart';

class SingleChatsRepo {
  final _firebaseDB = FirebaseDatabase.instance;

  DatabaseReference get userReference => _firebaseDB.reference().child('user');

  UserModel get currentUser => Get.find<AuthController>().user;

  Future<List<UserModel>> getFriendsList() async {
    List<UserModel> friends = [];
    final List friendsList = (await _firebaseDB.reference().child('user/' + currentUser.uid + "/friends").once()).value;

    for (final friendId in friendsList) {
      final friend = UserModel.fromDocument((await userReference.child(friendId).once()).value);
      friends.add(friend);
    }
    return friends;
  }
}
