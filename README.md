# friends_making

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Enabling Notification Service

## 1) Library Imports

- Import [firebase_messaging](https://pub.dev/packages/firebase_messaging) from [pub.dev](pub.dev) in pubspec.yaml
- Import [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

## 2) Configure Android XML

- Go to project/android/app/src/main and open AndroidManifest.xml file
- Under "application" tag inside "activity" tag (see AndroidManifest.xml structure), place the below code for Remote Notifications from FCM

```
<intent-filter>
    <action android:name="FLUTTER_NOTIFICATION_CLICK" />
    <category android:name="android.intent.category.DEFAULT" />
</intent-filter>
```
- For Flutter Local Notifications configuration, place the below code under "application" tag in AndroidManifest.xml file.
```
<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="high_importance_channel" />
```
- The android:value which is "high_importance_channel" depends on the channel you create in Dart when configuring Flutter location Notifications (Documented under Dart Conifguration for Flutter Location Notification).
## 3) Configure Kotlin file.
- Now go to project/android/app/src/main/kotlin/com/example/friends_making (the last route can depend on your package name for example, if your package name is com.company.someapp then the last route would be com/company/someapp)
- Create a new file with name Application.kt
- Place the code below in to your Application.kt file you just created

```
package com.example.friends_making // use package name appropriate for the app you created.

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
    }
}
```
- Go to Android.xml file again, and replace "io.flutter.app.FlutterApplication" from android:name under "application" tag, with ".Application"


# Enabling IOS Notifications

## 1) Library Imports
- Import [firebase_messaging](https://pub.dev/packages/firebase_messaging) from [pub.dev](pub.dev) in pubspec.yaml
- Import [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)


## 2) Configuring App Delegate
- go to ios/Runner/AppDelegate.swift file.
- place the below code for IOS notifications.

```
if #available(iOS 10.0, *) {
UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

## 3) Initializing The Plugin
- add the following code into dart file in order to initialize the plugin.

```
final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
```

- onDidReceiveLocalNotification is the method which defines the body of the notification.
- add the below code in dart code in order to initialize settings.

```
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS);
flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: onSelectNotification);
```
## 4) Notifications In App

- below code is used in app to call notification services in lib/main main.dart.


```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initFcm();

  runApp(App());
}

```

- to initialize notifications below code is used in the app lib/src/app/app.dart.

```
 void initState() {
    NotificationService.initNotifications();
    NotificationService.getPushToken();
    super.initState();
  }

```
- to get push token, place the below code into dart file.

```
NotificationService.pushToken;

```

- to call notification function, below code is used.

```
sendNotification('some body of notification','some title of notification','some toke of notification')
```


- to generate notification, below function is used to generate notificaiton


```
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

  ```
