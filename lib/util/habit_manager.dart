import 'dart:math';
import 'dart:typed_data';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HabitManager {

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static var id = 0;

  static Int64List vibrationPattern = Int64List.fromList([
    0, 1000, 5000, 1000
  ]);

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'elephant_reminder',
    'Elephant Reminders',
    'Elephant habit reminders',
    icon: 'elephant',
    importance: Importance.Max, 
    priority: Priority.High,
    vibrationPattern: vibrationPattern
  );
  static var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  static void scheduleAllHabits(List<Habit> habits) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    id = 0;

    for(Habit habit in habits){
      if(habit.isActive) await _scheduleHabit(habit);
    }

    var asd = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(asd.length);
  }

  static _scheduleHabit(Habit habit) async {
    if(habit.habitType == HabitType.RANDOM){
      await _scheduleRandom(habit);
    }else{
      await _scheduleScheduled(habit);
    }
  }

  static _scheduleRandom(Habit habit) async {
    List<Time> times = _getRandomTimes(habit);

    for(Time time in times){
      await _scheduleNotification(time, habit);
    }
  }

  static List<Time> _getRandomTimes(Habit habit){
    var times = List<Time>();
    var minuteDiff = (habit.maxHour - habit.minHour) * 60 + (habit.maxMin - habit.minMin);

    var minuteInterval = minuteDiff/habit.frequency;
    var secondsInterval = minuteInterval * 60;
    var previousTime = DateTime(0, 0, 0, habit.minHour, habit.minMin);

    for(int i=0; i < habit.frequency; i++){
      var dateTime = previousTime.add(Duration(seconds: secondsInterval.toInt()));
      previousTime = dateTime;
      dateTime.add(Duration(minutes: _randomMinute(habit)));
      times.add(Time(dateTime.hour, dateTime.minute));
    }

    return times;
  }

  static List<Time> _getScheduledTimes(ScheduledNotification schedule){
    var times = List<Time>();
    var minuteInterval = schedule.repeat;
    var secondsInterval = minuteInterval * 60;
    var dateTime = DateTime(0, 0, 0, schedule.hour, schedule.min);

    for(int i=0; i < schedule.frequency; i++){
      times.add(Time(dateTime.hour, dateTime.minute));
      dateTime = dateTime.add(Duration(seconds: secondsInterval.toInt()));
    }

    return times;
  }

  static int _randomMinute(Habit habit){
    Random random = new Random();
    var hourDiff = (habit.maxHour - habit.minHour);
        
    if(hourDiff > 1){
        return ((random.nextInt(hourDiff) - hourDiff) * 60);
    }else{
        return 0;
    }
  }

  static _scheduleScheduled(Habit habit) async {
    for(ScheduledNotification schedule in habit.scheduledNotificaitons){
      if(schedule.frequency != null){
        var times = _getScheduledTimes(schedule);

        for(Time time in times){
          await _scheduleNotification(time, habit);
        }
      }else{
        await _scheduleNotification(Time(schedule.hour, schedule.min), habit);
      }
    }
  }

  static Future<void> _scheduleNotification(Time time, Habit habit) async {
    print("${time.hour}${time.minute}");
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      habit.message,
      null,
      time,
      NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics)
    );

    id++;
  }

}