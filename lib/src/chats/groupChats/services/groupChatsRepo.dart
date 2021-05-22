import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/groupChats/controllers/groupChatsController.dart';
import 'package:friends_making/src/chats/groupChats/models/groupChat.dart';
import 'package:friends_making/src/chats/groupChats/models/groupMessage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GroupChatsRepo {
  Uuid uuid = Uuid();

  DatabaseReference chatReference;

  final _firebaseDB = FirebaseDatabase.instance.reference();

  DatabaseReference get userReference => _firebaseDB.child('user');

  DatabaseReference messageRef(String chatId) => _firebaseDB.child('groupMessages').child(chatId);

  UserModel get currentUser => Get.find<AuthController>().user;

  AuthController get authController => Get.find<AuthController>();

//*! Adding friends from user in authController to a list of 'friends' of type UserModel
  Future<List<UserModel>> getFriendsList() async {
    List<UserModel> friends = [];

    for (final friend in authController.user.friends) {
      final friendDoc = (await userReference.child(friend.friendId).once()).value;

      final UserModel friendObject = UserModel.fromDocument(friendDoc);

      friends.add(friendObject);
    }
    return friends;
  }

//*! To create a groupChat when 'Go to Chat' button clicked

  Future<void> createGroupChat(String chatRef, List<Friend> selectedFriends) async {
    var selectedFriendsMap = {};

    final messageId = DateTime.now().microsecondsSinceEpoch;

    final message = GroupMessage.fromDocument({
      'messageId': messageId.toString(),
      'messageTime': messageId,
      'senderName': currentUser.fullName,
      'senderImageUrl': currentUser.image,
      'senderId': currentUser.uid,
      'content': '${currentUser.fullName} added you to this Group Chat',
      'chatRef': chatRef
    });

    messageRef(chatRef).child(messageId.toString()).set(message.toJson());

    selectedFriends.forEach((friend) => selectedFriendsMap[friend.friendId] = friend.toJson());

    try {
      final chatSnap = {
        'chatId': chatRef,
        'recentMessage': '${currentUser.fullName} added you to this Group Chat',
        'lastUpdateTime': messageId,
        'createdAt': messageId.toString(),
        'chatMembers': selectedFriendsMap,
        'lastmsgsentby': currentUser.fullName,
        'lastmsgsentbyimgurl': currentUser.image
      };

      //*! Writes to current user's message list
      _firebaseDB
          .child('groupMessagesofAllUsers')
          .child(currentUser.uid)
          .child('groupChatsDetails/$chatRef')
          .set(chatSnap);

      //*! Write to other user's DB

      for (Friend friend in Get.find<GroupChatsController>().selectedFriendsChip) {
        _firebaseDB
            .child('groupMessagesofAllUsers')
            .child(friend.friendId)
            .child('groupChatsDetails/$chatRef')
            .set(chatSnap);
      }

      print(selectedFriendsMap);

      //*! TO DO - Print to other users' message List

    } on Exception catch (e) {
      print('Error from writing chatSnap to DOB: $e');
    }
  }

//*! selectedFriends List is chosen friends from UI
  Future<void> sendGroupMessage(String content, String chatRef, List<Friend> selectedFriends) async {
    var selectedFriendsMap = {};
    final messageId = DateTime.now().microsecondsSinceEpoch;

    final message = GroupMessage.fromDocument({
      'messageId': messageId.toString(),
      'messageTime': messageId,
      'senderName': currentUser.fullName,
      'senderImageUrl': currentUser.image,
      'senderId': currentUser.uid,
      'content': content,
      'chatRef': chatRef
    });

    messageRef(chatRef).child(messageId.toString()).set(message.toJson());

    selectedFriends.forEach((friend) => selectedFriendsMap[friend.friendId] = friend.toJson());

    try {
      final chatSnap = {
        'chatId': chatRef,
        'recentMessage': content,
        'lastUpdateTime': messageId,
        'createdAt': messageId.toString(),
        'chatMembers': selectedFriendsMap,
        'lastmsgsentby': currentUser.fullName,
        'lastmsgsentbyimgurl': currentUser.image
      };

      //*! Writes to current user's message list
      _firebaseDB
          .child('groupMessagesofAllUsers')
          .child(currentUser.uid)
          .child('groupChatsDetails/$chatRef')
          .set(chatSnap);

      for (Friend friend in Get.find<GroupChatsController>().selectedFriendsChip) {
        print(friend.name);
        _firebaseDB
            .child('groupMessagesofAllUsers')
            .child(friend.friendId)
            .child('groupChatsDetails/$chatRef')
            .set(chatSnap);
      }

      print(selectedFriendsMap);

      //*! TO DO - Print to other users' message List

      //TODO

    } on Exception catch (e) {
      print('Error from writing chatSnap to DOB: $e');
    }
  }
}
