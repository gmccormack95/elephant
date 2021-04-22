import 'dart:convert';

import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:Elephant/util/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'model/elephant_dart.dart';
import 'model/habit.dart';
import 'model/habit_type.dart';
import 'model/scheduled_notification.dart';
import 'model/settings_constants.dart';
import 'pages/home.dart';
import 'pages/intro_page.dart';
import 'util/ad_manager.dart';
import 'util/app_colors.dart';
import 'util/habit_manager.dart';
import 'widget/remove_glow.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await HabitManager.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //bool showIntro = await ElephantSettings.getBolean(SETTINGS_INTRO_SHOWN, false);
  bool showIntro = true;

  int loadCount = await ElephantSettings.getInt(SETTINGS_LOAD_COUNT, 0);
  ElephantSettings.setInt(SETTINGS_LOAD_COUNT, loadCount + 1);

  var habits = await getHabits();

  var initializationSettingsAndroid = AndroidInitializationSettings('elephant');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await HabitManager.flutterLocalNotificationsPlugin.initialize(initializationSettings);

  WidgetsFlutterBinding.ensureInitialized();
  AdManager.initalize();

  runApp(Elephant(showIntro, habits));
}

Future<List<Habit>> getHabits() async {
  var jsonString = await ElephantSettings.getString(SETTINGS_HABITS);

  if(jsonString == null){
    return [
      Habit(10, 'Drink Water', 8, 12, 0, 0, true, AppColors.defaultColors[0], HabitType.RANDOM, Habit.defaultDays),
      Habit(35, 'Be Mindful', 18, 22, 45, 0, true, AppColors.defaultColors[1], HabitType.SCHEDULED, Habit.defaultDays, scheduledNotificaitons: [
        ScheduledNotification(14, 15),
        ScheduledNotification(16, 0),
      ]),
      Habit(15, 'Sit up Straight', 12, 16, 0, 15, false, AppColors.defaultColors[2], HabitType.RANDOM, Habit.defaultDays),
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
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      
    return BlocProvider(
      create: (BuildContext context) => HabitBloc(habits),
      child: GetMaterialApp(
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
