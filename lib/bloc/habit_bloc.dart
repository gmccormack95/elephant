import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:Elephant/model/settings_constants.dart';
import 'package:Elephant/util/settings.dart';
import 'package:bloc/bloc.dart';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/habit_manager.dart';
import 'habit_event.dart';
import 'dart:math' as math;

class HabitBloc extends Bloc<HabitEvent, List<Habit>> {
  HabitBloc(this.habits) : super([]);

  List<Habit> habits;

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

    _storeHabitsInPrefs();
  }

  _storeHabitsInPrefs() {
    var json = jsonEncode(habits.map((e) => e.toJson()).toList());
    ElephantSettings.setString(SETTINGS_HABITS, json);
  }

}
