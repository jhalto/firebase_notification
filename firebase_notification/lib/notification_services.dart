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
    void initLocalNotifications(BuildContext context, RemoteMessage message)async{
         var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
        var iosInitializationSettings = DarwinInitializationSettings();

        var initializationSettings = InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (payload) {
             
          },
        );
    }
    void firebaseInit(BuildContext context){ 
      FirebaseMessaging.onMessage.listen((message) {
       
         print(message.notification!.title.toString());
       
      
         print(message.notification!.body.toString());
       initLocalNotifications(context, message);
       showNotification(message);
           
      });
    }
    
    Future<void> showNotification(RemoteMessage message)async{
       
       AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 
        'High Importance Notification',
        importance: Importance.high
        );
       AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
         channelDescription: "Your channel Description",
         importance: Importance.high,
         priority: Priority.high,
         ticker: 'ticker'
         );
         DarwinNotificationDetails  darwinNotificationDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        

         );
         NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: darwinNotificationDetails,
         );
        Future.delayed(Duration.zero,() {
          _flutterLocalNotificationsPlugin.show(
            0, 
            message.notification!.title.toString(),
            message.notification!.body.toString(),
             notificationDetails);
        });  
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
