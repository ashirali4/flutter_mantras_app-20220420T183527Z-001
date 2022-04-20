
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotifications{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();


  /// show scheduled notifications
  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required int hour,
    required int minute,
    required String type
  }) async => _notifications.zonedSchedule(
      id,
      title,
      body,
      type == "Repeat" ? _scheduleDaily(Time(hour,minute)) : _scheduleOnce(Time(hour,minute)),
      await _notificationDetails('$hour$minute'),
      payload: payload,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time
  );

  /// schedule for daily repeat
  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day,
      time.hour, time.minute, time.second
    );
    return scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;
  }

  /// schedule for once
  static tz.TZDateTime _scheduleOnce(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
        tz.local,
        now.year, now.month, now.day,
        time.hour, time.minute, time.second
    );
    return scheduledDate;
  }

  /// show single notifications
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => _notifications.show(
      id,
      title,
      body,
      await _notificationDetails('channel id'),
      payload: payload
  );

  // notification details
  static Future _notificationDetails(channelId) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          channelId,
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.high
      ),
      iOS: IOSNotificationDetails()
    );
  }

  //initialize notifications
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('app_icon');
    const ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android,iOS: ios);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async{
        onNotifications.add(payload);
      }
    );

    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

}