// ignore_for_file: avoid_print

import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  var postUrl = "fcm.googleapis.com/fcm/send";

  static Future<void> sendNotification(reciver, msg) {
    return Future.delayed(const Duration(seconds: 2), () {
      print("Sending notification");
    });
  }
}
