import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:friends_making/src/chats/services/singleChatsRepo.dart';
import 'package:get/get.dart';

class SingleChatsController extends GetxController {
  List<UserModel> friends = [];

  SingleChatsRepo repo = SingleChatsRepo();

  bool chatFound = false;

  bool isLoading = false;

  List<Message> messages = [];

  final authController = Get.find<AuthController>();

  void getFriends() async {
    isLoading = true;
    update();
    friends = await repo.getFriendsList();

    isLoading = false;
    update();
  }

  void getToChat(UserModel friend) async {
    for (final chatId in authController.user.chats) {
      if (chatId.contains(authController.user.uid) && chatId.contains(friend.uid)) {
        streamChat(chatId);
        chatFound = true;
      }
    }

    if (!chatFound) {
      createChat(friend);
    }
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
}

//CHAT MAIN
//
//
// "alskfjklasd": {
// id: asl;dkj,
// lastContent: 'sadfsdf'
// }
// 
// 
// USER DOC
// 
// "userDoc": {
//  chatsList" [asdfsdfaasd]
// }
