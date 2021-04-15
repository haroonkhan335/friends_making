import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:get/get.dart';

class Comment {
  String body;
  String commentId;
  String commenterId;
  String commenterImage;
  String commenterName;
  String commentTime;
  String postId;

  Comment({
    this.body,
    this.commenterId,
    this.commenterImage,
    this.commenterName,
    this.commentTime,
    this.commentId,
    this.postId,
  });

  factory Comment.fromDocument(doc) => Comment(
        body: doc['body'],
        commenterId: doc['commenterId'],
        commenterImage: doc['commenterImage'],
        commenterName: doc['commenterName'],
        commentTime: doc['commentTime'],
        commentId: doc['commentId'],
        postId: doc['postId'],
      );

  factory Comment.createNewComment(
          {String body, UserModel user, String postId}) =>
      Comment(
        body: body,
        commenterId: user.uid,
        commenterImage: user.image,
        commenterName: user.fullName,
        commentTime: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: postId,
        commentId: DateTime.now().microsecondsSinceEpoch.toString(),
      );

  Map<String, dynamic> toJson() => {
        'body': this.body,
        'commenterId': this.commenterId,
        'commenterImage': this.commenterImage,
        'commenterName': this.commenterName,
        'commentTime': this.commentTime,
        'postId': this.postId,
        'commentId': this.commentId,
      };
}
