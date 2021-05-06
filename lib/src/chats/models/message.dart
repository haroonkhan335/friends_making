class Message {
  String messageId;
  int messageTime;
  String senderName;
  String senderImageUrl;
  String senderId;
  String receiverId;
  String content;

  Message({
    this.messageId,
    this.messageTime,
    this.senderName,
    this.senderImageUrl,
    this.senderId,
    this.receiverId,
    this.content,
  });

  factory Message.fromDocument(doc) {
    return Message(
      messageId: doc['messageId'].toString(),
      messageTime: doc['messageTime'],
      senderName: doc['senderName'],
      senderImageUrl: doc['senderImageUrl'],
      senderId: doc['senderId'],
      content: doc['content'],
      receiverId: doc['receiverId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "messageId": messageId.toString(),
        "messageTime": messageTime,
        "senderName": this.senderName,
        "senderImageUrl": this.senderImageUrl,
        "senderId": this.senderId,
        "content": content,
        "receiverId": this.receiverId
      };
}
