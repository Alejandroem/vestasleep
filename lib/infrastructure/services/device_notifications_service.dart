import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/notifications_service.dart';

class DeviceNotificationsService extends NotificationsService {
  //AUDIO
  final audioPlayer = AudioPlayer();
  //LOCAL
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings =
      const InitializationSettings(
    android: AndroidInitializationSettings(
      'splash',
    ),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );

  //CALLS
  @override
  Future<bool> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    bool? notificationsIntialized =
        await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    PermissionStatus smsPermissionGranted = await Permission.sms.request();

    return notificationsIntialized != null &&
        notificationsIntialized &&
        smsPermissionGranted == PermissionStatus.granted;
  }

  @override
  Future<bool> sendLocalNotification(String title, String body) async {
    log('Sending local notification with title: $title and body: $body');
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
    try {
      String result = await sendSMS(
        message: body,
        recipients: contacts.map((e) => e.phone).toList(),
      );
      log(result);
      return true;
    } catch (e) {
      log('Error sending SMS: $e');
      return false;
    }
  }

  @override
  Future<bool> sendPushNotification(String title, String body) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> playAlarmSound() async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      //if not playing already
      if (audioPlayer.state != PlayerState.playing) {
        await audioPlayer.play(
          AssetSource(
            'sounds/alert.wav',
          ),
        );
      }
      return true;
    } catch (e) {
      log('Error playing sound: $e');
      return false;
    }
  }

  @override
  Future<bool> stopAlarmSound() async {
    try {
      await audioPlayer.stop();
      return true;
    } catch (e) {
      log('Error stopping audio player: $e');
      try {
        audioPlayer.release();
        return true;
      } catch (e) {
        log('Error releasing audio player: $e');
        return false;
      }
    }
  }
}
