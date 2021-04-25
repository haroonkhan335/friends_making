import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:friends_making/utils/notificationModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final String serverKey =
      "AAAA43r7Fe4:APA91bHPBhwPcAji3eqZWXjoJlwRWcz3_15D7djRfkED_V5-YudyeQrbktCsLlb-Up2Tn4AbldrRS_0rhkbemS3f8A_LAYGFSet2JduYJWI2RpAZpo_-ZA8wu9vacRuA912DsxcqVTyD";
  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidInitializationSettings initialzationSettingsAndroid;

  static InitializationSettings initializationSettings;

  static getPushToken() async {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      Get.find<AuthController>().refreshToken(token);
    });
    final token = await _firebaseMessaging.getToken();
    log('TOKEN: $token');
    return token;
  }

  static initFcm() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> initNotifications() async {
    initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final msg = NotificationModel.fromMessage(message.data);
      // if (message.data['imageUrl'] != null) {
      //   _showBigPictureNotification(
      //       url: msg.imageUrl, body: msg.body, title: msg.title);
      //   return;
      // }
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    print(message.data);
    // await flutterLocalNotificationsPlugin.show(
    //     message.data.hashCode,
    //     message.data['title'],
    //     message.data['body'],
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         channel.id,
    //         channel.name,
    //         channel.description,
    //       ),
    //     ));
  }

  static Future<http.Response> sendNotification({
    @required String body,
    @required String title,
    @required String token,
    String image,
  }) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": token,
        "priority": "high",
        "data": {'imageUrl': image ?? null},
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": body ?? '',
          "title": title ?? '',
          "sound": "default",
        }
      }),
    );
    return response;
  }
}
