import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/feedController.dart';
import 'package:get/get.dart';

class Feed extends StatelessWidget {
  final feedController = Get.put(FeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: feedController.getFeed(),
            builder: (context, snapshot) {
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
