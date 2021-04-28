class UserModel {
  String uid;
  String fullName;
  String image;
  String email;
  List friends = [];
  List followers = [];
  List followings = [];
  List posts = [];
  String pushToken;

  UserModel(
      {this.fullName,
      this.followers,
      this.posts,
      this.followings,
      this.email,
      this.pushToken,
      this.uid,
      this.friends,
      this.image});

  static UserModel fromDocument(doc) {
    return UserModel(
      fullName: doc['fullName'],
      uid: doc['uid'],
      image: doc['image'],
      posts: doc['posts'] != null ? [...doc['posts']] : [],
      email: doc['email'],
      followers: doc['followers'] ?? [],
      followings: doc['followers'] ?? [],
      pushToken: doc['pushToken'],
      friends: doc['friends'] ?? [],
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
      };
}
