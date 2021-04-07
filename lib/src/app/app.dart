import 'package:flutter/material.dart';
import 'package:friends_making/utils/pages.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Pages.AUTH_LANDING,
      getPages: Pages.getPages,
    );
  }
}
