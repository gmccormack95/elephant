import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:elephant/model/habit.dart';
import 'package:elephant/model/habit_type.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'habit_event.dart';

class HabitBloc extends Bloc<HabitEvent, List<Habit>> {
  HabitBloc() : super([]);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var habits = [
    Habit(10, 'Drink Water', 9, 17, 0, 0, true, AppColors.defaultColors[0], HabitType.RANDOM),
    Habit(35, 'Be Mindful', 18, 22, 45, 0, false, AppColors.defaultColors[1], HabitType.SCHEDULED),
    Habit(15, 'Sit up Straight', 12, 16, 0, 15, false, AppColors.defaultColors[2], HabitType.RANDOM),
  ];

  @override
  Stream<List<Habit>> mapEventToState(HabitEvent event) async* {
    if(event is LoadHabits){
      yield habits;
    }

    if(event is UpdateHabits){
      habits = List.from(event.habits);
      yield habits;
    }

    if(event is UpdateHabit){
      List<Habit> newHabits = List.from(habits);
      newHabits[event.index] = event.habit;
      habits = newHabits;
      yield habits;
    }

    if(event is CreateHabit){
      habits.add(event.habit);
      yield habits;
    }

    if(event is DeleteHabit){
      List<Habit> newHabits = List.from(habits);
      newHabits.removeAt(event.index);
      habits = newHabits;
      yield habits;
    }
  }

  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'elephant_reminder',
      'Elephant Reminders',
      'Elephant habit reminders',
      icon: 'elephant',
      color: Colors.blue
    );
    var iOSPlatformChannelSpecifics =IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

}
