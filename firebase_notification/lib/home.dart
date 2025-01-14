import 'package:firebase_notification/notification_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    
    // Request notification permission
    notificationServices.requestNotificationPermission();

    // Get device token and print it
    notificationServices.getDevicetoken().then((value) {
      if (value != null) {
        print("Device Token: $value");
      }
    });

    // Handle token refresh
    notificationServices.getRefreshToken();

    // Initialize Firebase messaging
    notificationServices.firebaseInit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}