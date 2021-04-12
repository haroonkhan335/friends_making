import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatelessWidget {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Text('Profile Picture', style: TextStyle(fontSize: 17)),
                  SizedBox(height: 20),
                  GetBuilder<AuthController>(
                    builder: (_) => authController.pickedFile == null
                        ? GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker.platform
                                  .pickImage(source: ImageSource.gallery);

                              if (pickedFile != null) {
                                log('Picked File path = ${pickedFile.path}');
                                authController.pickedFile =
                                    File(pickedFile.path);
                                authController.update();
                              }
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          )
                        : Image.file(
                            authController.pickedFile,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    validator: (v) {
                      if (v.length == 0) {
                        return 'Missing field';
                      }
                      return null;
                    },
                    controller: authController.fullNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Full Name',
                    ),
                  ),
                  SizedBox(height: 30),
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
                    child: Text('Sign Up'),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        authController.signUp();
                      }
                    },
                  ),
                  FlatButton(
                      child: Text('Already have an account? Login'),
                      onPressed: () {
                        Get.back();
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
