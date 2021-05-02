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

    log("FRIEND DOC === $friendDoc");

    if (friendDoc != null) {
      friendDoc.forEach((key, value) {
        friendsList.add(Friend.fromJson(value));
      });
    }

    log('FRIENDS LIST ${friendsList.length}');

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

class Friend {
  String friendId;
  String chatId;
  String image;
  String name;
  Friend({
    this.chatId,
    this.friendId,
    this.image,
    this.name,
  });

  factory Friend.fromJson(doc) {
    return Friend(
      chatId: doc['chatId'],
      friendId: doc['friendId'],
      image: doc['image'],
      name: doc['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': this.chatId,
        'friendId': this.friendId,
        'image': this.image,
        'name': this.name,
      };
}
