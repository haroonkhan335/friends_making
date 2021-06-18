import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/chats/groupChats/controllers/groupChatsController.dart';
import 'package:friends_making/src/chats/groupChats/widgets/filterChip.dart';
import 'package:friends_making/src/chats/groupChats/widgets/groupChatScreen.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GroupFriends extends StatefulWidget {
  @override
  _GroupFriendsState createState() => _GroupFriendsState();
}

class _GroupFriendsState extends State<GroupFriends> {
  final controller = Get.find<GroupChatsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.10),
          Text(
            'Who do you want to talk to today?',
            style: TextStyle(color: Colors.blueGrey),
          ),
          SizedBox(height: Get.height * 0.05),
          Expanded(
            child: GetBuilder<GroupChatsController>(
              builder: (_) => controller.currentUser.friends.length == 0
                  ? Center(
                      child: Text('No friends at the moment'),
                    )
                  : ListView.builder(
                      itemBuilder: (_, index) {
                        final user = controller.currentUser.friends[index];

                        return FilterChipWidgett(friendChip: user);
                      },
                      itemCount: controller.currentUser.friends.length,
                    ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final chatRefFromUi = Uuid().v1();

              controller.chatReference = chatRefFromUi;
              controller.update();
              controller.createGroupChats(chatRefFromUi);
              Get.to(
                GroupChatScreen(
                  chatRef: controller.chatReference,
                ),
              );

              print('chat members after go to chat clicked = ${controller.selectedFriendsChip}');
            },
            child: Text('Go to Chat'),
          ),
          SizedBox(height: Get.height * 0.10),
        ],
      ),
    );
  }
}
