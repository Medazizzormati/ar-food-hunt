import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize OneSignal only on mobile platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        OneSignal.initialize(AppConstants.oneSignalAppId);
        OneSignal.Notifications.requestPermission(true);
        
        // Set up notification handlers
        _setupNotificationHandlers();
      } catch (e) {
        debugPrint('OneSignal initialization failed: $e');
      }
    }
    
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _localNotifications.initialize(initializationSettings);
    
    _isInitialized = true;
  }

  void _setupNotificationHandlers() {
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('Notification clicked: ${event.notification.title}');
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint('Notification received in foreground: ${event.notification.title}');
    });
  }

  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'ar_food_hunt_channel',
      'AR Food Hunt Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Calculate delay from now
    final now = DateTime.now();
    final delay = scheduledTime.difference(now);
    
    if (delay.isNegative) {
      debugPrint('Scheduled time is in the past, not scheduling notification');
      return;
    }
    
    // Use Future.delayed instead of zonedSchedule to avoid timezone issues
    Future.delayed(delay, () {
      sendLocalNotification(title: title, body: body, payload: payload);
    });
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> subscribeToTopic(String topic) async {
    // OneSignal topic subscription to be implemented with correct API
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    // OneSignal topic unsubscription to be implemented with correct API
    debugPrint('Unsubscribed from topic: $topic');
  }

  Future<String?> getUserId() async {
    final status = await OneSignal.User.pushSubscription.id;
    return status;
  }
}
