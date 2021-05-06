class Chat {
  String chatId;
  String recentMessage;
  int lastUpdateTime;
  String createdAt;
  List chatMembers;

  Chat({
    this.chatId,
    this.recentMessage,
    this.lastUpdateTime,
    this.createdAt,
    this.chatMembers,
  });

  factory Chat.fromDocument(doc) => Chat(
        chatId: doc['chatId'],
        recentMessage: doc['recentMessage'],
        lastUpdateTime: doc['lastUpdateTime'],
        createdAt: doc['createdAt'],
        chatMembers: doc['chatMembers'],
      );

  Map<String, dynamic> toJson() => {
        "chatId": this.chatId,
        "recentMessage": this.recentMessage,
        "lastUpdateTime": this.lastUpdateTime,
        "createdAt": this.createdAt,
        "chatMembers": this.chatMembers,
      };
}
