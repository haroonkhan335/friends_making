import 'dart:developer';

class UserModel {
  String uid;
  String fullName;
  String image;
  String email;
  List<Friend> friends = [];
  List followers = [];
  List followings = [];
  List posts = [];
  String pushToken;
  List chats = [];

  UserModel(
      {this.fullName,
      this.followers,
      this.posts,
      this.followings,
      this.email,
      this.pushToken,
      this.uid,
      this.chats,
      this.friends,
      this.image});

  static UserModel fromDocument(doc) {
    List<Friend> friendsList = [];
    final friendDoc = doc['friends'];
    if (friendDoc != null) {
      friendDoc.forEach((key, value) {
        friendsList.add(Friend.fromJson(value));
      });
    }
    return UserModel(
      fullName: doc['fullName'],
      uid: doc['uid'],
      image: doc['image'],
      posts: doc['posts'] != null ? [...doc['posts']] : [],
      email: doc['email'],
      followers: doc['followers'] ?? [],
      followings: doc['followers'] ?? [],
      pushToken: doc['pushToken'],
      friends: friendsList,
      chats: doc['chats'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'fullName': this.fullName,
        'image': this.image,
        'email': this.email,
        'followers': this.followers,
        'followings': this.followings,
        'posts': this.posts,
        'friends': this.friends,
        'pushToken': this.pushToken,
        'chats': this.chats,
      };
}

enum FriendStatus { Pending, Accepted, Rejected }

class Friend {
  /* 
    status: 0 = 'pending'
    status: 1 = 'accepted',
    status: 2 = Rejected
  */

  String friendId;
  String chatId;
  String image;
  String name;
  FriendStatus friendStatus;
  Friend({
    this.chatId,
    this.friendId,
    this.image,
    this.name,
    this.friendStatus,
  });

  factory Friend.fromJson(doc) {
    return Friend(
      chatId: doc['chatId'],
      friendId: doc['friendId'],
      image: doc['image'],
      name: doc['name'],
      friendStatus: evaluateStatus(doc['friendStatus']),
    );
  }

  static FriendStatus evaluateStatus(String status) {
    if (status == 'pending') {
      return FriendStatus.Pending;
    } else if (status == 'accepted') {
      return FriendStatus.Accepted;
    } else if (status == 'rejected') {
      return FriendStatus.Rejected;
    }
  }

  Map<String, dynamic> toJson() => {
        'chatId': this.chatId,
        'friendId': this.friendId,
        'friendStatus': this.friendStatus.toString().toLowerCase(),
        'image': this.image,
        'name': this.name,
      };
}
