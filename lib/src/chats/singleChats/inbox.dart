import 'package:flutter/material.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:get/get.dart';

class Inbox extends StatelessWidget {
  final controller = Get.put(SingleChatsController());
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('INBOX'));
  }
}
