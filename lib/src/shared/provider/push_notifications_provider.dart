import 'dart:developer';
import 'package:alcancia/main.dart';
import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  inspect(message);
}

void firebaseMessagingOpenAppHandler(RemoteMessage message) {
  navigatorKey.currentContext!.go("/registration");
}

void handleInitialMessage(RemoteMessage message) {
  navigatorKey.currentContext!.go("/login");
}

class PushNotificationProvider {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    messaging.requestPermission();

    messaging.getToken().then((token) {
      // device token
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleInitialMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingOpenAppHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Fluttertoast.showToast(
          msg: message.notification!.body!,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: alcanciaLightBlue,
          timeInSecForIosWeb: 5);
      inspect(message);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      // send to dashboard screen
      navigatorKey.currentContext!.go("/registration");
    });
  }
}

final pushNotificationProvider = Provider((ref) => PushNotificationProvider());
