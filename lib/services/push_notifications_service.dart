//SHA1: DD:4B:43:9D:70:26:DD:9C:73:0B:C5:CF:4B:D2:0A:4D:71:7B:C5:11

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('_backgroundHandler ${message.messageId}');
    _messageStream.add(message.notification?.body ?? 'no title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('_onMessageHandler ${message.data}');
    _messageStream.add(message.data['producto'] ?? 'no data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('_onMessageOpenApp ${message.messageId}');
    print('_onMessageHandler ${message.data}');

    _messageStream.add(message.data['producto'] ?? 'no data');
  }

  static Future initiazeApp() async {
    //todo push notificactions
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //local notificactions
  }

  static CloseStreams() {
    _messageStream.close();
  }
}
