import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Call once after Firebase.initializeApp() when a user is signed in.
  Future<void> initialize(String uid) async {
    if (_initialized) return;
    _initialized = true;

    // 1. Request permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Register FCM token
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveFcmToken(uid, token);
    }

    // 3. Refresh token listener
    _fcm.onTokenRefresh.listen((newToken) {
      _saveFcmToken(uid, newToken);
    });

    // 4. Init local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // 5. Foreground message handler
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
  }

  Future<void> _saveFcmToken(String uid, String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'fcmToken': token});
    } catch (_) {
      // Silently ignore — user doc may not exist yet during first sign-in
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'millio_channel',
          'Millio Notifications',
          channelDescription: 'Millio app notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
