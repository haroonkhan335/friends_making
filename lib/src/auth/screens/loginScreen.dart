import 'package:flutter/material.dart';
import 'package:friends_making/consts/socialLoginButtons.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                TextFormField(
                  validator: (v) {
                    if (!v.isEmail) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  controller: authController.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  validator: (v) {
                    if (v.length == 0 || v.length < 3) {
                      return 'Password\'s length must be greater than 3';
                    }
                    return null;
                  },
                  controller: authController.passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 50),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      authController.login();
                    }
                  },
                ),
                FlatButton(
                    child: Text('Don\'t have an account? Sign Up'),
                    onPressed: () {
                      Get.toNamed(Pages.SIGN_UP);
                    }),
                Divider(
                  height: 2,
                  color: Colors.grey,
                  thickness: 2,
                ),
                SocialLoginButtons.facebook,
                SizedBox(height: 25),
                SocialLoginButtons.google,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
