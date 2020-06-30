import 'package:elephant/model/habit_type.dart';
import 'package:flutter/material.dart';

class Habit {
  Habit(
    this.frequency, 
    this.message,
    this.minHour,
    this.maxHour,
    this.minMin,
    this.maxMin,
    this.isActive,
    this.color,
    this.habitType
  );

  int frequency; 
  String message;
  int minHour;
  int maxHour;
  int minMin;
  int maxMin; 
  bool isActive;
  Color color;
  HabitType habitType;
}