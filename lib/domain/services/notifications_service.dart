import '../models/contact.dart';

abstract class NotificationsService {
  Future<bool> requestNotificationPermissions();
  Future<bool> sendLocalNotification(String title, String body);
  Future<bool> sendPushNotification(String title, String body);
  Future<bool> sendPhoneNotificationToContacts(
      String title, String body, List<VestaContact> contacts);
  Future<bool> sendEmergencyResponseNotification(
      String title, String body, List<VestaContact> contacts);
  Future<bool> playAlarmSound();
  Future<bool> stopAlarmSound();
}
