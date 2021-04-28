import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/chatController.dart';
import 'package:get/get.dart';

class Chats extends StatelessWidget {
  final controller = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: GetBuilder<ChatController>(
        builder: (_) => Container(
          height: 50,
          width: Get.width,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.changeTab(Tabs.Chats);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: controller.selectedTab == Tabs.Chats
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text('Inbox'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.changeTab(Tabs.Groups);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: controller.selectedTab == Tabs.Groups
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text('Group'),
                    ),
                  ),
                ),
              ),
              // controller.selectedTab == Tabs.Chats ? ChatList() : Groups()
            ],
          ),
        ),
      ),
    );
  }
}


//16516161
//
//16516169


/// Followers: ['alsdjfklsj', 'skalfjklsdf'];
/// 
/// 
/// firebase.database.ref('skldjfsl').delete({followers: ['alskdjla', asd;kfaj, alksdfjsl]})