import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  int i = 0;

  bool isEditing = true;

  List<String> currentTags = [];

  TextEditingController bodyPostController = TextEditingController();
  TextEditingController postTagsController = TextEditingController();

  Stream getFeed() {
    FirebaseDatabase.instance
        .reference()
        .child('user')
        .orderByChild('fullName')
        .onValue
        .listen((Event event) {
      print(event.snapshot.value);
    });
  }

  void finishWritingPost() {
    currentTags = postTagsController.text.split(',');
    isEditing = false;
    update();
    print('TAGS $currentTags');
  }

  void toggleEditing() {
    isEditing = true;
    update();
  }

  void post() {
    //TODO: UPload to firebase
  }
}
