


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:friends_making/src/chats/groupChats/services/groupChatsRepo.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';



class GroupChatsController extends GetxController{

List<Friend> friends = [];




List<Friend> selectedFriendsChip = [];


GroupChatsRepo repo = GroupChatsRepo();

List<Message> messages = [];

String chatReference;


Color containerColour;


void changeColour (){
  containerColour = Colors.amber;
  update();
}






final authController = Get.find<AuthController>();

UserModel get currentUser => authController.user;

TextEditingController messageController = TextEditingController();




Future<void> createGroupChats (chatReferenceFromUi) async {


  await repo.createGroupChat(chatReferenceFromUi, selectedFriendsChip);
 
}



Future<void> sendGroupMessage (String chatReferencefromUI) async {

await repo.sendGroupMessage(messageController.text, chatReferencefromUI, selectedFriendsChip);

}



}