class Chat {
  String chatid;
  String recentMessage;
  String lastUpdateTime;
  String createdAt;
  List chatMembers;

  Chat({
    this.chatid,
    this.recentMessage,
    this.lastUpdateTime,
    this.createdAt,
    this.chatMembers,
  });

  factory Chat.fromDocument(doc) => Chat(
        chatid: doc['chatid'],
        recentMessage: doc['recentMessage'],
        lastUpdateTime: doc['lastUpdateTime'],
        createdAt: doc['createdAt'],
        chatMembers: doc['chatMembers'],
      );

  Map<String, dynamic> toJson() => {
        "chatid": this.chatid,
        "recentMessage": this.recentMessage,
        "lastUpdateTime": this.lastUpdateTime,
        "createdAt": this.createdAt,
        "chatMembers": this.chatMembers,
      };
}
