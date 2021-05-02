import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/utils/notificationService.dart';
import 'package:get/get.dart';

import 'src/app/app.dart';
import 'src/auth/models/userModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initFcm();

  // FirebaseDatabase.instance
  //     .reference()
  //     .child('user/pXn7F6EU7ePjpWA2Ogl2Tp0AhSE2')
  //     .child('friends/askdfjlkanv29830')
  //     .update({
  //   "friendId": "askdfjlkanv29830",
  //   "chatId": "askldjflk234",
  // });
  //
  final user = await FirebaseDatabase.instance.reference().child('user/pXn7F6EU7ePjpWA2Ogl2Tp0AhSE2').once();

  print("USER === ${jsonDecode(jsonEncode(user.value))}");

  runApp(App());
}
