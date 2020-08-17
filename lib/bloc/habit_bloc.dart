import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/habit_manager.dart';
import 'habit_event.dart';
import 'dart:math' as math;

class HabitBloc extends Bloc<HabitEvent, List<Habit>> {
  HabitBloc() : super([]);

  var habits = [
    Habit(10, 'Drink Water', 8, 12, 0, 0, true, AppColors.defaultColors[0], HabitType.RANDOM),
    Habit(35, 'Be Mindful', 18, 22, 45, 0, true, AppColors.defaultColors[1], HabitType.SCHEDULED, scheduledNotificaitons: [
      ScheduledNotification(14, 15, 30, 5),
      ScheduledNotification(16, 0, null, null),
    ]),
    Habit(15, 'Sit up Straight', 12, 16, 0, 15, false, AppColors.defaultColors[2], HabitType.RANDOM),
  ];

  @override
  Stream<List<Habit>> mapEventToState(HabitEvent event) async* {
    if(event is LoadHabits){
      yield habits;
    }

    if(event is UpdateHabits){
      habits = List.from(event.habits);
      HabitManager.scheduleAllHabits(habits);
      yield habits;
    }

    if(event is UpdateHabit){
      List<Habit> newHabits = List.from(habits);
      newHabits[event.index] = event.habit;
      habits = newHabits;
      HabitManager.scheduleAllHabits(habits);
      yield habits;
    }

    if(event is DeleteHabit){
      List<Habit> newHabits = List.from(habits);
      newHabits.removeAt(event.index);
      habits = newHabits;
      yield habits;
    }

  }

}
