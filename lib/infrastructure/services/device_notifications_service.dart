import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony/telephony.dart';

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
    // TODO: implement sendPhoneNotificationToContacts

    try {
      for (VestaContact contact in contacts) {
        log('Sending SMS to ${contact.name}');
        await telephony.sendSms(
          to: contact.phone,
          message: body,
        );
      }
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
