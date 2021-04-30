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

- Import [firebase_messaging](https://pub.dev/packages/firebase_messaging) from [pub.dev] in pubspec.yaml
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


