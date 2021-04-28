import 'package:get/get.dart';

enum Tabs { Chats, Groups }

class ChatController extends GetxController {
  Tabs selectedTab = Tabs.Chats;

  void changeTab(Tabs tab) {
    selectedTab = tab;
    update();
  }
}
