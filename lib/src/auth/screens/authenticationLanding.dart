import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/screens/loginScreen.dart';
import 'package:friends_making/src/home/screens/homeScreen.dart';

import 'package:get/get.dart';

class AuthenticationLanding extends StatefulWidget {
  @override
  _AuthenticationLandingState createState() => _AuthenticationLandingState();
}

class _AuthenticationLandingState extends State<AuthenticationLanding> {
  final authController = Get.put(AuthController());
  @override
  void initState() {
    authController.currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (_) => authController.user == null &&
                authController.isAuthenticationCompleted == false
            ? Scaffold(body: Center(child: CircularProgressIndicator()))
            : authController.user == null &&
                    authController.isAuthenticationCompleted
                ? LoginScreen()
                : HomeScreen());
  }
}
