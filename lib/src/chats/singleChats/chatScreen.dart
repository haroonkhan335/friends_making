import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:friends_making/src/chats/models/message.dart';
import 'package:get/get.dart';

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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<Object>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('messages')
                    .child(widget.friend.chatId)
                    .orderByChild("messageTime")
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  print("SNAPSHOT HAS DATA ${snapshot.hasData}");
                  if (snapshot.hasData) {
                    List<Message> messages = [];
                    final doc = snapshot.data.snapshot.value;

                    if (doc == null) {
                      return Center(child: Text('No messages yet'));
                    }

                    doc.forEach((key, value) {
                      messages.add(Message.fromDocument(value));
                    });

                    messages.sort((message1, message2) => message2.messageTime.compareTo(message1.messageTime));
                    return ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (_, index) {
                          final message = messages[index];
                          return ListTile(
                            leading: Container(
                              height: 25,
                              width: 25,
                              child: CachedNetworkImage(
                                imageUrl: message.senderImageUrl,
                                imageBuilder: (_, image) => CircleAvatar(
                                  backgroundImage: image,
                                ),
                              ),
                            ),
                            title: Text(message.senderName),
                            subtitle: Text(message.content),
                          );
                        });
                  }
                  return SizedBox();
                },
              ),
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
        ));
  }
}
