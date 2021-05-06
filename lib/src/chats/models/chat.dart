import 'dart:developer';

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
    print("MEMBERS $members");
    if (members != null) {
      members.forEach((key, value) {
        log("VALUE $value");
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> members = {};

    for (final ChatMember member in this.chatMembers) {
      members[member.id] = member.toJson();
    }
    return {
      "chatId": this.chatId,
      "recentMessage": this.recentMessage,
      "lastUpdateTime": this.lastUpdateTime,
      "createdAt": this.createdAt,
      "chatMembers": members,
    };
  }
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'name': name,
      };
}
