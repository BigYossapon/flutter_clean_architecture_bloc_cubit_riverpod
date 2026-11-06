import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Func {
  static void showLocalNotification(RemoteNotification? notification) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '99',
      'Clean',
      importance: Importance.max,
      priority: Priority.high,
    );
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(interruptionLevel: InterruptionLevel.active);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0, // Notification ID
      title: notification?.title ?? '', // Notification title
      body: notification?.body ?? '', // Notification body
      notificationDetails: platformChannelSpecifics,
    );
  }

  static bool isVersionCompatible(
    String currentVersion,
    String minimumVersion,
  ) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> minimum = minimumVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < current.length; i++) {
      if (current[i] > minimum[i]) {
        print("compare is true");
        return true; // Current version is greater than minimum version.
      } else if (current[i] < minimum[i]) {
        print("compare is false");
        return false; // Current version is less than minimum version.
      }
    }

    print("compare is true");
    return true; // Versions are equal.
  }

  static Future<PackageInfo> getAppinfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
