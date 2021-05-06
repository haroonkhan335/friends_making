import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';

class ChatScreen extends StatefulWidget {
  final Friend friend;
  ChatScreen({this.friend});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.find<SingleChatsController>();
  @override
  void initState() {
    super.initState();
    controller.getMessages(widget.friend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: WillPopScope(
          onWillPop: () {
            while (Get.currentRoute != '/auth_landing') {
              Get.back();
            }
            return Future.value(true);
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<Object>(
                    stream: FirebaseDatabase.instance
                        .reference()
                        .child('messages')
                        .child(widget.friend.chatId)
                        .orderByChild("messageTime")
                        .onValue,
                    builder: (_, AsyncSnapshot snapshot) {
                      List<Message> messages = [];
                      if (snapshot.hasData) {
                        final docs = snapshot.data.snapshot.value;

                        if (docs == null) {
                          return Center(child: Text('No messages yet'));
                        }

                        docs.forEach((key, value) {
                          messages.add(Message.fromDocument(value));
                        });

                        messages.sort((message1, message2) => message2.messageTime.compareTo(message1.messageTime));

                        print('MESSAGE LENGTH == ${messages.length}');
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (_, i) {
                            final message = messages[i];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: message.senderId == controller.currentUser.uid
                                  ? RightBubble(message)
                                  : LeftBubble(message),
                            );

                            // return ListTile(
                            //   title: Text(message.senderName),
                            //   leading: Container(
                            //     height: 25,
                            //     width: 25,
                            //     child: CachedNetworkImage(
                            //       imageUrl: message.senderImageUrl,
                            //       imageBuilder: (_, image) => CircleAvatar(
                            //         backgroundImage: image,
                            //       ),
                            //     ),
                            //   ),
                            //   subtitle: Text(message.content),
                            // );
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
                        controller.sendMessage(widget.friend);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}

class RightBubble extends StatelessWidget {
  final Message message;

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
          Text(message.content, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Text("${DateFormat('yyyy-mm-dd hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(message.messageTime))}")
        ],
      ),
      padding: BubbleEdges.symmetric(horizontal: 10, vertical: 10),
      radius: Radius.circular(8),
    );
  }
}

class LeftBubble extends StatelessWidget {
  final Message message;

  LeftBubble(this.message);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.centerLeft,
      color: Colors.blue,
      nip: BubbleNip.rightBottom,
      child: Column(
        children: [
          Text(message.content, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      padding: BubbleEdges.symmetric(horizontal: 5, vertical: 10),
      radius: Radius.circular(8),
    );
  }
}
