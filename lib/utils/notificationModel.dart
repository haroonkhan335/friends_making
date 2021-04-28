class NotificationModel {
  String body;
  String title;

  NotificationModel({this.body, this.title});

  factory NotificationModel.fromMessage(Map<String, dynamic> message) =>
      NotificationModel(body: message['body'], title: message['title']);
}
