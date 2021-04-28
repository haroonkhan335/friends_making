import 'package:flutter/material.dart';
import 'package:friends_making/utils/notificationService.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    NotificationService.initNotifications();
    NotificationService.getPushToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Pages.AUTH_LANDING,
      getPages: Pages.getPages,
    );
  }
}
