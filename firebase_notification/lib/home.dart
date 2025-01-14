import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notification/notification_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    
    super.initState();
    NotificationServices().requestNotificationPermission();
    NotificationServices().getDevicetoken().then((value) {
      print("device token");
      print(value);
    
    },);
    // NotificationServices().firebaseInit();
    NotificationServices().getRefreshToken();
    NotificationServices().firebaseInit();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}