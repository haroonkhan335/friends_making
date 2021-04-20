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

  void getFollowers() async {
    if (!hasGottenFollowers) {
      isLoading = true;
      update();

      followers = await repo.getFollowers();

      isLoading = false;

      update();
    }
  }

  // Haroon
  //
  // [h, ha, har, haro, haroo, haroon]

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
    authController.user.followings.add(followingUser.uid);
    authController.update();
    update();
  }
}
