// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen o'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: homeController.nameController,
              decoration: const InputDecoration(
                hintText: 'Enter name',
              ),
            ),
            TextField(
              controller: homeController.msgController,
              decoration: const InputDecoration(
                hintText: 'Enter messege',
              ),
            ),
            ElevatedButton(
                // onPressed: () {},
                onPressed: () => homeController
                    .saveDeviceToken(homeController.nameController.text),
                child: const Text('Save Device Token')),
            ElevatedButton(
                // onPressed: () {},
                onPressed: () => HomeController.sendNotification(
                    homeController.nameController.text,
                    homeController.msgController.text),
                child: const Text('Send Notification')),
          ],
        ),
      ),
    );
  }
}
