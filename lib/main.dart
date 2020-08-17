import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages/home.dart';
import 'util/habit_manager.dart';
import 'widget/remove_glow.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await HabitManager.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('elephant');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await HabitManager.flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(Elephant());
}

class Elephant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HabitBloc(),
      child: MaterialApp(
        title: 'Elephant',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
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
