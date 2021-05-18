import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/auth/services/authServices.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  File pickedFile;

  UserModel user;

  bool isHiddenPassword = true;

  bool isAuthenticationCompleted = false;

  AuthService authService = AuthService();

  Future<void> currentUser() async {
    user = await authService.getCurrentUser();
    isAuthenticationCompleted = true;
    update();
  }

  void login() async {
    this.user = await authService.login(emailController.text, passwordController.text);
    update();
  }

  void setFile(File file) {
    pickedFile = file;
    update();
  }

  void signUp() async {
    if (pickedFile == null) {
      Get.snackbar('', '', titleText: Text('Please select an image', style: TextStyle(color: Colors.red)));
      return;
    }
    user = await authService.signUpUser(emailController.text, passwordController.text,
        image: pickedFile, userData: {'fullName': fullNameController.text, 'email': emailController.text});
    if (user != null) Get.back();
    update();
  }

  void logOut() async {
    user = await authService.logOut();
    update();
  }

  void refreshToken(String pushToken) async {
    user.pushToken = pushToken;
    update();
    await authService.refreshToken(pushToken);
  }
}
