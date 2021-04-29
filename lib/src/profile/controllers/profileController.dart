import 'package:firebase_database/firebase_database.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/home/models/post.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {


  UserModel user;

  List<Post> posts = [];



  void loadPosts(String uid) async {

    try{
    final postIds =
        FirebaseDatabase.instance.reference().child('user/$uid/posts').onValue;

        print('post Ids: $postIds');
        print('uid: $uid');

        

    final post = Post.fromDocument(
      (FirebaseDatabase.instance.reference().child('posts/$postIds').once()),
    );

    print('post: $post');    
    posts.add(post);
    update();

    } catch (e){
      print(e);
    }
  }

}
