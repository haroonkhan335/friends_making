import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:get/get.dart';

class SingleChatsRepo {
  final _firebaseDB = FirebaseDatabase.instance.reference();

  DatabaseReference get userReference => _firebaseDB.child('user');

  DatabaseReference messageRef(String chatId) => _firebaseDB.child('messages/$chatId');

  UserModel get currentUser => Get.find<AuthController>().user;

  AuthController get authController => Get.find<AuthController>();

  Future<List<UserModel>> getFriendsList() async {
    List<UserModel> friends = [];
    for (final friend in authController.user.friends) {
      final friendDoc = (await userReference.child(friend.friendId).once()).value;

      final UserModel friendObject = UserModel.fromDocument(friendDoc);
      friends.add(friendObject);
    }
    return friends;
  }

  Future<List<Message>> getMessages(Friend friend) async {
    final messages = _firebaseDB.child('messages').child(friend.chatId).once();

    return [];
  }

  Future<void> sendMessage(Friend friend, String content) async {
    final messageId = DateTime.now().microsecondsSinceEpoch;

    final message = Message.fromDocument({
      "messageId": messageId.toString(),
      "messageTime": messageId,
      "senderName": currentUser.fullName,
      "senderImageUrl": currentUser.image,
      "senderId": currentUser.uid,
      "content": content,
      "receiverId": friend.friendId,
    });

    await messageRef(friend.chatId).child(messageId.toString()).set(message.toJson());

    _firebaseDB.child('userChats').child(currentUser.uid).child(friend.chatId).set({
      "chatId": friend.chatId,
      "recentMessage": message.content,
      "lastUpdateTime": message.messageTime,
      "chatMembers": [message.senderId, message.receiverId],
    });
    _firebaseDB.child('userChats').child(message.receiverId).child(friend.chatId).set({
      "chatId": friend.chatId,
      "recentMessage": message.content,
      "lastUpdateTime": message.messageTime,
      "chatMembers": [message.senderId, message.receiverId],
    });
  }
}
