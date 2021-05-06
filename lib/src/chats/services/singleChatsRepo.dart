import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/models/chat.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:get/get.dart';

class SingleChatsRepo {
  final _firebaseDB = FirebaseDatabase.instance.reference();

  DatabaseReference get userReference => _firebaseDB.child('user');

  DatabaseReference messageRef(String chatId) => _firebaseDB.child('messages').child(chatId);

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
      "receiverId": friend.friendId
    });

    messageRef(friend.chatId).child(messageId.toString()).set(message.toJson());

    final chatDocFromFB = (await _firebaseDB.child('userChats/${currentUser.uid}').child(friend.chatId).once()).value;

    if (chatDocFromFB != null) {
      _firebaseDB.child('userChats/${currentUser.uid}').child(friend.chatId).update({
        "recentMessage": content,
        "lastUpdateTime": messageId,
      });
      _firebaseDB.child('userChats/${friend.friendId}').child(friend.chatId).update({
        "recentMessage": content,
        "lastUpdateTime": messageId,
      });
    } else {
      final chatbox = Chat.fromDocument({
        "chatId": friend.chatId,
        "recentMessage": content,
        "lastUpdateTime": messageId,
        "createdAt": messageId.toString(),
        "chatMembers": {
          currentUser.uid: {"id": currentUser.uid, "image": currentUser.image, "name": currentUser.fullName},
          friend.friendId: {"id": friend.friendId, "image": friend.image, "name": friend.name},
        }
      });
      _firebaseDB.child('userChats/${currentUser.uid}').child(friend.chatId).set(chatbox.toJson());
      _firebaseDB.child('userChats/${friend.friendId}').child(friend.chatId).set(chatbox.toJson());
    }
  }
}
