import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/services/repository.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  final repo = Repository();
  final authController = Get.find<AuthController>();
  bool isLoading = false;

  List<UserModel> usersToFollow = [];

  void getUsers() async {
    isLoading = true;
    update();

    usersToFollow = await repo.getAllUsers();

    isLoading = false;
    update();
  }

  void followUser({UserModel followingUser, UserModel currentUser}) async {
    await repo.followUser(
        followingUser: followingUser, currentUser: currentUser);
    authController.user.followings.add(followingUser.uid);
    authController.update();
    update();
  }
}
