class GroupMessage {

String messageId;
int messageTime;
String senderName;
String senderImageUrl;
String senderId;
String content;
String chatRef;


GroupMessage({
  this.messageId,
  this.messageTime,
  this.senderName,
  this.senderImageUrl,
  this.senderId,
  this.content,
  this.chatRef
  
});

factory GroupMessage.fromDocument(doc) {
  return GroupMessage(
    messageId: doc['messageId'].toString(),
    messageTime: doc['messageTime'],
    senderName: doc['senderName'],
    senderImageUrl: doc['senderImageUrl'],
    senderId: doc['senderId'],
    content: doc['content'],
    chatRef: doc['chatRef']
  );
}

Map<String, dynamic> toJson() => {
  'messageId': messageId.toString(),
  'messageTime': messageTime,
  'senderName': this.senderName,
  'senderImageUrl': this.senderImageUrl,
  'senderId': this.senderId,
  'content': content,
  'chatRef': chatRef
};


}