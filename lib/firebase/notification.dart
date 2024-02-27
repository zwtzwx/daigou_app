/*
  firebase 消息推送
 */
import 'dart:convert' as convert;
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/storage/user_storage.dart';

class Notifications {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static AndroidNotificationChannel? channel;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static initialized() {
    initForegroudSetting();
    getToken();
    registerMessage();
  }

  // 获取 device token
  static void getToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      UserStorage.setDeviceToken(token);
    }
  }

  // Foregroud notification setting
  static void initForegroudSetting() async {
    if (Platform.isAndroid) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin!.initialize(
        initializationSettings,
        onSelectNotification: (payload) {
          if (payload != null) {
            Map<String, dynamic> data = convert.jsonDecode(payload);
            onMessage(data);
          }
        },
      );
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);
    } else if (Platform.isIOS) {
      // ios 启动前台消息通知
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // 消息通知
  static void registerMessage() async {
    // ios 会唤起用户授权、android 直接授予权限
    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Foregroud state message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // android 前台本地提示消息
        if (message.notification != null &&
            message.notification!.android != null) {
          flutterLocalNotificationsPlugin?.show(
            message.notification.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true,
              ),
            ),
            payload: convert.jsonEncode(message.data),
          );
        }
      });
      // Background state message
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        onMessage(message.data);
      });
      // Terminated state message
      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        onMessage(initialMessage.data);
      }
    }
  }

  // 处理消息
  // type 1: 包裹入库 2: 订单待支付、3: 订单发货、4: 充值结果、5: 支付成功 6: 二程单号更新
  // value: ['order_id']
  static void onMessage(Map<String, dynamic>? data) {
    if (data == null) return;
    if (data['type'] == '1') {
      BeeNav.push(BeeNav.orderCenter, arg: 1);
    } else if (data['type'] == '7') {
      BeeNav.push(BeeNav.webview,
          arg: {'type': 'notice', 'id': int.parse(data['value'])});
    } else if (data['type'] == '8') {
      BeeNav.push(BeeNav.orderDetail, arg: {'id': num.parse(data['value'])});
    }
  }
}
