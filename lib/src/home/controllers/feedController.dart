import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  int i = 0;
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
}
