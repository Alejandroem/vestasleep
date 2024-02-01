import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/notifications_service.dart';

class FlutterNotificationsService extends NotificationsService {
  @override
  Future<bool> sendLocalNotification(String title, String body) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'local_notifications',
      'VestaSleep Notifications',
      'VestaSleep alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
    return true;
  }

  @override
  Future<bool> sendEmergencyResponseNotification(
      String title, String body, List<VestaContact> contacts) {
    // TODO: implement sendEmergencyResponseNotification
    throw UnimplementedError();
  }

  @override
  Future<bool> sendPhoneNotificationToContacts(
      String title, String body, List<VestaContact> contacts) {
    // TODO: implement sendPhoneNotificationToContacts
    throw UnimplementedError();
  }

  @override
  Future<bool> sendPushNotification(String title, String body) {
    // TODO: implement sendPushNotification
    throw UnimplementedError();
  }
}
