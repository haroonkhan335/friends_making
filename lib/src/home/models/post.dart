import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:get/get.dart';

class Post {
  String body;
  String postId;
  String posterId;
  String posterFullName;
  String posterProfilePicture;
  List tags;
  String postTime;
  List likes = [];
  List comments = [];

  Post({
    this.body,
    this.comments,
    this.likes,
    this.postTime,
    this.postId,
    this.posterId,
    this.tags,
    this.posterFullName,
    this.posterProfilePicture,
  });

  factory Post.fromDocument(doc) => Post(
        body: doc['body'],
        posterId: doc['posterId'],
        tags: doc['tags'] ?? [],
        postTime: doc['postTime'],
        comments: doc['comments'] ?? [],
        likes: doc['likes'] ?? [],
        postId: doc['postId'],
        posterFullName: doc['posterFullName'],
        posterProfilePicture: doc['posterProfilePicture'],
      );

  factory Post.createNewPost({String body, List tags}) => Post(
        body: body,
        tags: tags,
        postId: DateTime.now().microsecondsSinceEpoch.toString(),
        posterId: Get.find<AuthController>().user.uid,
        postTime: DateTime.now().microsecondsSinceEpoch.toString(),
        likes: [],
        posterFullName: Get.find<AuthController>().user.fullName,
        posterProfilePicture: Get.find<AuthController>().user.image,
        comments: [],
      );

  Map<String, dynamic> toJson() => {
        'body': this.body,
        'posterId': this.posterId,
        'tags': this.tags,
        'postTime': this.postTime,
        'likes': this.likes,
        'postId': this.postId,
        'comments': this.comments,
        'posterFullName': this.posterFullName,
        'posterProfilePicture': this.posterProfilePicture,
      };
}
