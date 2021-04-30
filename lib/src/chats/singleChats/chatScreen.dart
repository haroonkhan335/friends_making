import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final UserModel friend;
  ChatScreen({this.friend});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.find<SingleChatsController>();
  @override
  void initState() {
    super.initState();
    controller.getToChat(widget.friend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
    );
  }
}
