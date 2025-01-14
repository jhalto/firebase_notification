import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
    
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    void requestNotificationPermission()async{
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true,
          sound: true,
    
        );
        if(settings.authorizationStatus ==AuthorizationStatus.authorized){
               print("user granted permission");
        }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
          print("User granted provisional permission");
        }else{
          print("user denied permission");
          AppSettings.openAppSettings();
        }
    }
    void inintLocalNotifications(BuildContext context, RemoteMessage message)async{
         var androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
        var iosInitializationSettings = DarwinInitializationSettings();

        var initializationSetting = InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSetting,
          onDidReceiveNotificationResponse: (details) {
             
          },
        );
    }
    void firebaseInit(){ 
      FirebaseMessaging.onMessage.listen((message) {
       if (kDebugMode) {
         print(message.notification!.title.toString());
       }
       if (kDebugMode) {
         print(message.notification!.body.toString());
       }
       showNotification(message);
           
      });
    }
    Future<void> showNotification(RemoteMessage message)async{
       
       AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(), 
        'High Importance Notification',
        importance: Importance.max
        );
       AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
         channelDescription: "Your channel Description",
         importance: Importance.high,
         priority: Priority.high,
         ticker: 'ticker'
         );
         DarwinNotificationDetails 
        Future.delayed(Duration.zero,() {
          
        },);  
    } 
    Future<String> getDevicetoken()async{
    String? token = await messaging.getToken();
      return token!;
    }
    void getRefreshToken(){

      messaging.onTokenRefresh.listen((event) {
        event.toString();
        print(event.toString());
        print("refresh");
      },
      );
    }
}