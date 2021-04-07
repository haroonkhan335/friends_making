import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/app/app.dart';
import 'src/auth/models/userModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final data =
  //     (await FirebaseDatabase.instance.reference().child('user').once()).value;
  // List<UserModel> users = [];
  // data.forEach((key, value) {
  //   users.add(UserModel.fromDocument(value));
  // });

  // for (final user in users) {
  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child('user/' + user.uid)
  //       .child('followers')
  //       .push();
  // }
  // await FirebaseAuth.instance.signOut();
  runApp(App());
}
