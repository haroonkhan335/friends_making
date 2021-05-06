import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:friends_making/src/chats/services/singleChatsRepo.dart';
import 'package:get/get.dart';

class SingleChatsController extends GetxController {
  List<Friend> friends = [];

  SingleChatsRepo repo = SingleChatsRepo();

  bool chatFound = false;

  bool isLoading = false;

  List<Message> messages = [];

  final authController = Get.find<AuthController>();

  UserModel get currentUser => authController.user;

  TextEditingController messageController = TextEditingController();

  void getMessages(Friend friend) async {
    FirebaseDatabase.instance.reference().child('messages').child(friend.chatId).onChildAdded.listen((event) {});
  }

  void streamChat(String chatId) async {
    FirebaseDatabase.instance.reference().child('chats').child(chatId).child('messages').onValue.listen((event) {
      final message = Message.fromDocument(event.snapshot.value);
      messages.add(message);
    });
  }

  void createChat(UserModel friend) async {
    final chatId = authController.user.uid + friend.uid;

    Map<String, dynamic> chatDocument = {
      "chatid": chatId,
      "recentMessage": "",
      "lastUpdateTime": DateTime.now().microsecondsSinceEpoch.toString(),
      "createdAt": DateTime.now().microsecondsSinceEpoch.toString(),
      "chatMembers": [
        {"id": friend.uid, "imageUrl": friend.image},
        {"id": authController.user.uid, "imageUrl": authController.user.image},
      ],
    };
    await FirebaseDatabase.instance.reference().child('chats').child(chatId).set(chatDocument);
  }

  Future<void> sendMessage(Friend friend) async {
    if (messageController.text.isNotEmpty) {
      await repo.sendMessage(friend, messageController.text);
      messageController.clear();
    }
  }
}
