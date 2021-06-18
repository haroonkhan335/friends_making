import 'package:friends_making/src/auth/models/userModel.dart';

class GroupChat {
  String chatId;
  String recentMessage;
  int lastUpdateTime;
  String createdAt;
  List chatMembers;
  String lastmsgsentby;
  String lastmsgsentbyimgurl;

  GroupChat(
      {this.chatId,
      this.recentMessage,
      this.lastUpdateTime,
      this.createdAt,
      this.chatMembers,
      this.lastmsgsentby,
      this.lastmsgsentbyimgurl});

  factory GroupChat.fromDocument(doc) {
    List<GroupChatMember> chatMembers = [];
    final members = doc['chatMembers'];

    if (members != null) {
      members.forEach((key, value) {
        chatMembers.add(GroupChatMember.fromDocument(value));
      });
    }

    return GroupChat(
        chatId: doc['chatId'],
        recentMessage: doc['recentMessage'],
        lastUpdateTime: doc['lastUpdateTime'],
        createdAt: doc['createdAt'],
        chatMembers: chatMembers,
        lastmsgsentby: doc['lastmsgsentby'],
        lastmsgsentbyimgurl: doc['lastmsgsentbyimgurl']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> members = {};

    for (final GroupChatMember member in this.chatMembers) {
      members[member.id] = member.toJson();
    }

    return {
      'chatId': this.chatId,
      'recentMessage': this.recentMessage,
      'lastUpdateTime': this.lastUpdateTime,
      'createdAt': this.createdAt,
      'chatMembers': members,
      'lastmsgsentby': this.lastmsgsentby,
      'lastmsgsentbyimgurl': this.lastmsgsentbyimgurl
    };
  }
}

class GroupChatMember {
  String id;
  String image;
  String name;

  GroupChatMember({this.id, this.image, this.name});

  factory GroupChatMember.fromDocument(doc) {
    return GroupChatMember(id: doc['id'], image: doc['image'], name: doc['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'image': image, 'name': name};
}
