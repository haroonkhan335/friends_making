import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/chats/controllers/singleChatsController.dart';
import 'package:friends_making/src/chats/singleChats/chatScreen.dart';
import 'package:get/get.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final controller = Get.find<SingleChatsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(controller.currentUser.friends);
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<SingleChatsController>(
                builder: (_) => controller.currentUser.friends.length == 0
                    ? Center(child: Text('You have no friends at the moment'))
                    : ListView.builder(
                        itemBuilder: (_, index) {
                          final user = controller.currentUser.friends[index];
                          return ListTile(
                            title: Text(user.name),
                            trailing: IconButton(
                                icon: Icon(Icons.message),
                                onPressed: () {
                                  Get.to(ChatScreen(friend: user));
                                }),
                            leading: Container(
                              height: 60,
                              width: 60,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.to(ProfileScreen(user: user));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: user.image,
                                  imageBuilder: (context, image) => CircleAvatar(
                                    backgroundImage: image,
                                    radius: 30,
                                  ),
                                  errorWidget: (context, errorMessage, data) => CircleAvatar(
                                    child: Icon(Icons.account_circle_outlined),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.currentUser.friends.length,
                      )),
          ),
        ],
      ),
    );
  }
}
