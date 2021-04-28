import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:friends_making/utils/notificationService.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: Text('Call'),
            onPressed: () async {
              await NotificationService.sendNotification(
                  body: "TEST NOTIFICATION",
                  title: "Notfification from haroon",
                  token:
                      'eo1JmM2NS5eW0Sy-UVxquU:APA91bE2uooscsPyh5F-AOaI93KHGBzY2qYtR7Lkq_T5F_vPJoDZvVtcce4isLg6xh9CqFgNh3OB-DcfKNiPiCOuzlHVPZf05u0jjiuzh9vC3wDvi4x4TFBs687HxhKItHzA6jKHYRm6');
            }),
      ),
    );
  }
}



/// Followers: ['alsdjfklsj', 'skalfjklsdf'];
/// 
/// 
/// firebase.database.ref('skldjfsl').delete({followers: ['alskdjla', asd;kfaj, alksdfjsl]})