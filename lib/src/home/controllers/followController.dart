import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/services/repository.dart';
import 'package:get/get.dart';

enum TAB { Followers, Followings }

class FollowController extends GetxController {
  final repo = Repository();
  final authController = Get.find<AuthController>();
  bool isLoading = false;

  bool hasGottenFollowers = false;

  bool hasGottenFollowings = false;

  TAB selectedTab = TAB.Followers;

  List<UserModel> followers = [];

  List<UserModel> followings = [];

  List<UserModel> allUsers = [];

  UserModel get currentUser => Get.find<AuthController>().user;

  void getFollowers() async {
    if (!hasGottenFollowers) {
      isLoading = true;
      update();

      followers = await repo.getFollowers();

      isLoading = false;

      update();
    }
  }

  void getFollowings() async {
    if (!hasGottenFollowings) {
      isLoading = true;
      update();

      followings = await repo.getFollowings();
      hasGottenFollowings = true;

      isLoading = false;
      update();
    }
  }

  void followUser({UserModel followingUser, UserModel currentUser}) async {
    await repo.followUser(
        followingUser: followingUser, currentUser: currentUser);

    final listOfFollwers = [
      ...authController.user.followings,
      followingUser.uid
    ];
    authController.user.followings = listOfFollwers;

    log('FOLLOWERS === ${authController.user.followings.length}');
    allUsers.removeWhere((user) => user.uid == followingUser.uid);
    authController.update();
    update();
  }

  void getAllUser() async {
    isLoading = true;
    update();
    allUsers = await repo.allUsers();
    isLoading = false;
    update();
  }



//TO DO 

  void unFollowUser({UserModel currentUser, UserModel followingUser}) async {

  try {

    await repo.unFollowUser(currentUser, followingUser);
    update();

  } on Exception catch (e) {
      print(e);
  }

  }



}
