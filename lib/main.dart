import 'dart:convert';

import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:Elephant/util/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/habit.dart';
import 'model/habit_type.dart';
import 'model/scheduled_notification.dart';
import 'model/settings_constants.dart';
import 'pages/home.dart';
import 'pages/intro_page.dart';
import 'util/app_colors.dart';
import 'util/habit_manager.dart';
import 'widget/remove_glow.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await HabitManager.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //bool showIntro = await ElephantSettings.getBolean(SETTINGS_INTRO_SHOWN, false);
  bool showIntro = true;

  var habits = await getHabits();

  var initializationSettingsAndroid = AndroidInitializationSettings('elephant');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await HabitManager.flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(Elephant(showIntro, habits));
}

Future<List<Habit>> getHabits() async {
  var jsonString = await ElephantSettings.getString(SETTINGS_HABITS);

  if(jsonString == null){
    return [
      Habit(10, 'Drink Water', 8, 12, 0, 0, true, AppColors.defaultColors[0], HabitType.RANDOM),
      Habit(35, 'Be Mindful', 18, 22, 45, 0, true, AppColors.defaultColors[1], HabitType.SCHEDULED, scheduledNotificaitons: [
        ScheduledNotification(14, 15, 30, 5),
        ScheduledNotification(16, 0, null, null),
      ]),
      Habit(15, 'Sit up Straight', 12, 16, 0, 15, false, AppColors.defaultColors[2], HabitType.RANDOM),
    ];
  }

  Iterable l = json.decode(jsonString);
  return List<Habit>.from(l.map((model)=> Habit.fromJson(model)));
}

class Elephant extends StatelessWidget {
  Elephant(this.showIntro, this.habits);

  final bool showIntro;
  final List<Habit> habits;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HabitBloc(habits),
      child: MaterialApp(
        title: 'Elephant',
        debugShowCheckedModeBanner: false,
        home: showIntro 
          ? IntroductionPage()
          : HomePage(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RemoveGlow(),
            child: MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)
            )
          );
        },
      ),
    );
  }
}
