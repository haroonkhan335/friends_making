class Feed {
  String body;
  String posterId;
  String tags;
  DateTime postTime;
  List likes = [];
  List comments = [];

  Feed(
      {this.body,
      this.comments,
      this.likes,
      this.postTime,
      this.posterId,
      this.tags});

  factory Feed.fromDocument(doc) => Feed(
        body: doc['body'],
        posterId: doc['posterId'],
        tags: doc['tags'] ?? [],
        postTime: doc['postTime'],
        comments: doc['comments'] ?? [],
        likes: doc['likes'],
      );

  Map<String, dynamic> toJson() => {
        'body': this.body,
        'posterId': this.posterId,
        'tags': this.tags,
        'postTime': this.postTime,
        'likes': this.likes,
        'comments': this.comments
      };
}
