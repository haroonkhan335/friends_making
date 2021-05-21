import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/chats/groupChats/controllers/groupChatsController.dart';
import 'package:friends_making/src/chats/groupChats/models/groupChat.dart';
import 'package:friends_making/src/chats/groupChats/widgets/groupChatScreen.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupInbox extends StatelessWidget {
  final controller = Get.put(GroupChatsController());

  @override
  Widget build(BuildContext context) {
    print("ROUTE  ${Get.currentRoute}");
    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('groupMessagesofAllUsers')
                    .child(controller.currentUser.uid)
                    .child('groupChatsDetails')
                    .onValue,
                builder: (_, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<GroupChat> chats = [];
                    final docs = snapshot.data.snapshot.value;

                    if (docs == null) {
                      return Center(child: Text("No Chats Yet"));
                    }

                    docs.forEach((key, value) {
                      chats.add(GroupChat.fromDocument(value));
                    });

                    print("CHATS LIST == ${chats.length}");

                    chats.sort((chat1, chat2) => chat2.lastUpdateTime.compareTo(chat1.lastUpdateTime));

                    return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (_, i) {
                          final chat = chats[i];
                          final chatRef = chats[i].chatId; //*! to pass chatRef to send to next screen

                          // GroupChatMember otherMember = chat.chatMembers
                          //     .where((member) => member.id != controller.currentUser.uid)
                          //     .toList()
                          //     .first;

                          return ListTile(
                            onTap: () {
                              Get.to(GroupChatScreen(
                                chatRef: chatRef,
                              )); //*! passing chatRef to next screen
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: chat.lastmsgsentbyimgurl,
                                imageBuilder: (_, image) => CircleAvatar(
                                  backgroundImage: image,
                                ),
                              ),
                            ),
                            title: Text(chat.lastmsgsentby),
                            subtitle: Text("${chat.lastmsgsentby} says ${chat.recentMessage}"),
                            trailing: Text(timeago.format(DateTime.fromMicrosecondsSinceEpoch(chat.lastUpdateTime))),
                          );
                        });
                  }

                  return SizedBox();
                }))
      ],
    );
  }
}
