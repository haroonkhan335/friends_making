class UserModel {
  String uid;
  String fullName;
  String image;
  String email;
  List followers = [];
  List followings = [];
  List posts = [];

  UserModel(
      {this.fullName,
      this.followers,
      this.posts,
      this.followings,
      this.email,
      this.uid,
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
      };
}
