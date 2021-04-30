class Message {
  String messageId;
  String messageTime;
  String senderName;
  String senderImageUrl;
  String senderId;
  String content;

  Message({
    this.messageId,
    this.messageTime,
    this.senderName,
    this.senderImageUrl,
    this.senderId,
    this.content,
  });

  factory Message.fromDocument(doc) => Message(
        messageId: doc['messageId'],
        messageTime: doc['messageTime'],
        senderName: doc['senderName'],
        senderImageUrl: doc['senderImageUrl'],
        senderId: doc['senderId'],
        content: doc['content'],
      );
}
