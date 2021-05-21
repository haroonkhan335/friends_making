import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:friends_making/src/chats/models/chat.dart';
import 'package:friends_making/src/chats/singleChats/chatScreen.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class Inbox extends StatelessWidget {
  final controller = Get.put(SingleChatsController());
  @override
  Widget build(BuildContext context) {
    print("ROUTE  ${Get.currentRoute}");
    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseDatabase.instance.reference().child('userChats').child(controller.currentUser.uid).onValue,
                builder: (_, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Chat> chats = [];
                    final docs = snapshot.data.snapshot.value;

                    if (docs == null) {
                      return Center(child: Text("No Chats Yet"));
                    }

                    docs.forEach((key, value) {
                      chats.add(Chat.fromDocument(value));
                    });

                    print("CHATS LIST == ${chats.length}");

                    chats.sort((chat1, chat2) => chat2.lastUpdateTime.compareTo(chat1.lastUpdateTime));

                    return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (_, i) {
                          final chat = chats[i];
                          ChatMember otherMember = chat.chatMembers
                              .where((member) => member.id != controller.currentUser.uid)
                              .toList()
                              .first;

                          return ListTile(
                            onTap: () {
                              final Friend friend = controller.currentUser.friends
                                  .where((friend) => friend.friendId == otherMember.id)
                                  .toList()
                                  .first;
                              Get.to(ChatScreen(friend: friend));
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: otherMember.image,
                                imageBuilder: (_, image) => CircleAvatar(
                                  backgroundImage: image,
                                ),
                              ),
                            ),
                            title: Text(otherMember.name),
                            subtitle: Text(chat.recentMessage),
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
