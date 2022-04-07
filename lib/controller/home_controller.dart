// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  // get it from console.firebase.google.com  => project/<your Project >/settings/cloudmessaging
  static const String serverKey =
      'AAAAa4phy8g:APA91bG2oC8W6KcPNPjfXf1fBXownmQO71ptXfe2lyKqJVHgXq76rPyvOyuiCqHjWQFSoBy7SFjXHsfrXMxJU1qOJXWRDWovRvCk1OujFG54z_3Eg5b1bMjnNEFjKK5jPbu86EAvK1fR';

  static Uri postUrl = Uri.parse("https://fcm.googleapis.com/fcm/send");

  static Future<void> sendNotification(reciverId, msg) async {
    var token = await getToken(userId: reciverId);
    print('token : $token');

    final data = {
      "notification": {"title": "Notification From $reciverId", "body": "$msg"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": token
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$serverKey'
    };

    try {
      final response =
          await http.post(postUrl, body: json.encode(data), headers: headers);
      print('response : ${response.body}');
      if (response.statusCode == 200) {
        Get.snackbar('Notification Sent', 'Request Sent To $reciverId');
      } else {
        Get.snackbar('Notification Failed', 'Request Failed To Send',
            backgroundColor: Colors.red);
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
      Get.snackbar('UnKnown Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  static Future<String> getToken({userId}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot snapshot =
        await firestore.collection('users').doc(userId).get();
    return snapshot['token'];
  }

//saving token while signing in or signing up

  saveDeviceToken(String userID) async {
    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance.collection('users').doc(userID);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
      });
    }
  }
}
