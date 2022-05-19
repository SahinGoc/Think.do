import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationsService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  Future init({initScheduled = false}) async {
    final android = AndroidInitializationSettings('mipmap/ic_launcher');
    final settings = InitializationSettings(
      android: android,
    );

    final details = await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await notificationsPlugin.initialize(settings,
        onSelectNotification: ((payload) {
      onNotifications.add(payload);
    }));

    if(initScheduled){
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          importance: Importance.max,
          channelDescription: 'channel description'),
    );
  }

  Future showNotifications(
      {int id = 0,
        String? title,
        String? body,
        String? payload}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future showScheduledNotifications(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future showDailyNotifications(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime scheduledTime}) async =>
      notificationsPlugin.zonedSchedule(
          id, title, body, scheduleDaily(Time(8)), await notificationDetails(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
  tz.TZDateTime scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }
}
