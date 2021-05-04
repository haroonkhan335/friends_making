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

  // FirebaseDatabase.instance.reference().child('chats/ksdjlk2jlk23').set({
  //   "chatId": "ksdjlk2jlk23",
  //   "members": {
  //     "pXn7F6EU7ePjpWA2Ogl2Tp0AhSE2": true,
  //     "lakjdflkasjdfkl": true,
  //   },
  // });
  // FirebaseDatabase.instance.reference().child('chats/5sd6f46a5sd4f6').set({
  //   "chatId": "ksdjlk2jlk23",
  //   "members": {
  //     "k23jh4kksjafh": true,
  //     "lakjdflkasjdfkl": true,
  //   },
  // });

  print("DATE ${DateTime.now().microsecondsSinceEpoch}");

  final dumm = await FirebaseDatabase.instance.reference().child('chats').child('members').once();

  dumm.value.forEach((e, v) {
    print("V $v  ${DateTime.fromMicrosecondsSinceEpoch(v['time'])}");
  });

  // final user =
  //     await FirebaseDatabase.instance.reference().child('/pXn7F6EU7ePjpWA2Ogl2Tp0AhSE2').equalTo(true).once();

  // print("USER === ${jsonDecode(jsonEncode(user.value))}");

  runApp(App());
}
