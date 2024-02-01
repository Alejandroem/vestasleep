import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony/telephony.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/notifications_service.dart';

class DeviceNotificationsService extends NotificationsService {
  //LOCAL
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings =
      const InitializationSettings(
    android: AndroidInitializationSettings(
      'splash',
    ),
  );

  //SMS
  final Telephony telephony = Telephony.instance;

  //CALLS
  @override
  Future<bool> requestNotificationPermissions() async {
    bool? notificationsIntialized =
        await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    bool? smsPermissionGranted = await telephony.requestPhoneAndSmsPermissions;

    return notificationsIntialized != null &&
        smsPermissionGranted != null &&
        notificationsIntialized &&
        smsPermissionGranted;
  }

  @override
  Future<bool> sendLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'local_notifications',
      'VestaSleep Notifications',
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
      String title, String body, List<VestaContact> contacts) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendPhoneNotificationToContacts(
      String title, String body, List<VestaContact> contacts) async {
    // TODO: implement sendPhoneNotificationToContacts

    try {
      for (VestaContact contact in contacts) {
        await telephony.sendSms(
          to: contact.phone,
          message: body,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> sendPushNotification(String title, String body) {
    // TODO: implement sendPushNotification
    throw UnimplementedError();
  }
}
