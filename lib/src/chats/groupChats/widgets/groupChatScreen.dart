import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/groupChats/controllers/groupChatsController.dart';
import 'package:friends_making/src/chats/groupChats/models/groupMessage.dart';
import 'package:friends_making/src/chats/groupChats/widgets/filterChip.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupChatScreen extends StatefulWidget {
  final chatRef; //*! chatRef passed from inbox screen

  GroupChatScreen({this.chatRef});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final controller = Get.find<GroupChatsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Container(
            height: Get.height * 0.10,
            child: Row(
              children: [
                Container(
                    child: Text(
                  'Friends in Chat:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
                SizedBox(width: Get.width * 0.10),
                Expanded(
                  child: Container(
                            child: Scrollbar(
                              child: StreamBuilder<Object>(
                                  stream: FirebaseDatabase.instance
                                      .reference()
                                      .child('groupMessagesofAllUsers')
                                      .child(
                                          Get.find<AuthController>().user.uid)
                                      .child('groupChatsDetails')
                                      .child(widget.chatRef)
                                      .child('chatMembers')
                                      .onValue,
                                  builder: (_, AsyncSnapshot snapshot) {
                                    List<Friend> chatMembers = [];
                                    if (snapshot.hasData) {
                                      final docs = snapshot.data.snapshot.value;

                                      if (docs == null) {
                                        return Center(
                                            child: Text('No Friends selected'));
                                      }

                                      docs.forEach((key, value) {
                                        chatMembers.add(Friend.fromJson(value));
                                      });

                                      print('Chat Members Group == $chatMembers');

                                      return ListView.builder(
                                        reverse: true,
                                        itemCount: chatMembers.length,
                                        itemBuilder: (_, i) {
                                          final chatMember = chatMembers[i];

                                          return Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: chatMember.image,
                                                imageBuilder:
                                                    (context, image) =>
                                                        CircleAvatar(
                                                  backgroundImage: image,
                                                  radius: Get.width * 0.03,
                                                ),
                                                errorWidget: (context,
                                                        errorMessage, data) =>
                                                    CircleAvatar(
                                                  radius: Get.width * 0.03,
                                                  child: Icon(Icons
                                                      .account_circle_outlined),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 2, 2, 2),
                                                child: Text(
                                                  chatMember.name,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    return Center(
                                        child: Text('Nooooo messages yet'));
                                  }),

                              //  ListView.builder(
                              //   itemBuilder: (_, index) {
                              //     final user = controller.selectedFriendsChip[index];

                              //     return Row(
                              //       children: [
                              //         CachedNetworkImage(
                              //     imageUrl: user.image,
                              //     imageBuilder: (context, image) => CircleAvatar(
                              //       backgroundImage: image,
                              //       radius: Get.width*0.03,
                              //     ),
                              //        errorWidget: (context, errorMessage, data) => CircleAvatar(
                              //          radius: Get.width*0.03,
                              //       child: Icon(Icons.account_circle_outlined),
                              //     ),
                              //   ),
                              //         Container(
                              //           padding: EdgeInsets.fromLTRB(10, 2, 2, 2),
                              //           child: Text(user.name, style: TextStyle(fontSize: 12),)),
                              //       ],
                              //     );
                              //   },
                              //   itemCount: controller.selectedFriendsChip.length,
                              // ),
                            ),
                          ),
                  
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Object>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('groupMessages')
                    .child(widget.chatRef) //*! accessing the chatRef
                    .orderByChild("messageTime")
                    .onValue,
                builder: (_, AsyncSnapshot snapshot) {
                  List<GroupMessage> groupMessages = [];
                  if (snapshot.hasData) {
                    final docs = snapshot.data.snapshot.value;

                    if (docs == null) {
                      return Center(child: Text('No messages yet'));
                    }

                    docs.forEach((key, value) {
                      groupMessages.add(GroupMessage.fromDocument(value));
                    });

                    groupMessages.sort((message1, message2) =>
                        message2.messageTime.compareTo(message1.messageTime));

                    print('MESSAGE LENGTH == ${groupMessages.length}');

                    return ListView.builder(
                      reverse: true,
                      itemCount: groupMessages.length,
                      itemBuilder: (_, i) {
                        final groupMessage = groupMessages[i];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: groupMessage.senderId ==
                                  controller.currentUser.uid
                              ? RightBubble(groupMessage)
                              : LeftBubble(groupMessage),
                        );
                      },
                    );
                  }
                  return Center(child: Text('Nooooo messages yet'));
                }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    controller.sendGroupMessage(widget.chatRef);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RightBubble extends StatelessWidget {
  final GroupMessage message; //*! Group message passed from above

  RightBubble(this.message);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.centerRight,
      color: Colors.blue,
      nip: BubbleNip.rightBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.content,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Text(
            "${DateFormat('yyyy-mm-dd hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(message.messageTime))}",
            style: TextStyle(fontSize: 10),
          ),
          Text(
            message.senderName,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      padding: BubbleEdges.symmetric(horizontal: 10, vertical: 10),
      radius: Radius.circular(8),
    );
  }
}

class LeftBubble extends StatelessWidget {
  final GroupMessage message;

  LeftBubble(this.message);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.centerLeft,
      color: Colors.amber,
      nip: BubbleNip.rightBottom,
      child: Column(
        children: [
          Text(message.content,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Text(
            "${DateFormat('yyyy-mm-dd hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(message.messageTime))}",
            style: TextStyle(fontSize: 10),
          ),
          Text(
            message.senderName,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      padding: BubbleEdges.symmetric(horizontal: 5, vertical: 10),
      radius: Radius.circular(8),
    );
  }
}
