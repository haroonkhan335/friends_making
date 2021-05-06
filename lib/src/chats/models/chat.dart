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

  factory Chat.fromDocument(doc) {
    List<ChatMember> chatMembers = [];
    final members = doc['chatMembers'];
    if (members != null) {
      members.forEach((key, value) {
        chatMembers.add(ChatMember.fromDocument(value));
      });
    }
    print("CHAT MEMBERS $chatMembers");
    return Chat(
      chatId: doc['chatId'],
      recentMessage: doc['recentMessage'],
      lastUpdateTime: doc['lastUpdateTime'],
      createdAt: doc['createdAt'],
      chatMembers: chatMembers,
    );
  }

  Map<String, dynamic> toJson() => {
        "chatId": this.chatId,
        "recentMessage": this.recentMessage,
        "lastUpdateTime": this.lastUpdateTime,
        "createdAt": this.createdAt,
        "chatMembers": this.chatMembers,
      };
}

class ChatMember {
  String id;
  String image;
  String name;

  ChatMember({
    this.id,
    this.image,
    this.name,
  });

  factory ChatMember.fromDocument(doc) {
    return ChatMember(
      id: doc['id'],
      image: doc['image'],
      name: doc['name'],
    );
  }
}
