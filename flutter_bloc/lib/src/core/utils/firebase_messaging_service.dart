import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:osDOE/src/core/constants/app_constants.dart';

// import '../../../../main.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}

class FirebaseMessagingService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseMessaging.instance.requestPermission();

    final settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    firebaseMessaging.onTokenRefresh.listen((fcm) {
      // Constants.fcmToken = fcm;
      print('fcm token is changed');
    });

    if (Platform.isIOS) {
      await Future.delayed(Duration(seconds: 3));
      String? APNSToken = '';
      try {
        APNSToken = await firebaseMessaging.getAPNSToken();
      } catch (e) {
        print(e.toString());
      }
      // await firebaseMessaging.subscribeToTopic('');
      final fCMToken = await firebaseMessaging.getToken();

      // Constants.fcmToken = fCMToken!;
      print('Token: $fCMToken');
      print('APNSToken: $APNSToken');
    } else {
      final fCMToken = await firebaseMessaging.getToken();

      // Constants.fcmToken = fCMToken!;
      print('Token: $fCMToken');
    }

    // Initialize the local notification plugin
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    firebaseMessaging.getInitialMessage().then((data) {
      print("success");
    });
  }

  Future<void> checkPermissionNotification() async {}

  Future<void> enableNotification() async {
    // Constants.isFirebaseNotificationOn = true;
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> disableNotification() async {
    // Constants.isFirebaseNotificationOn = false;
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }
}
