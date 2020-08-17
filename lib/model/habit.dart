import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Habit extends Equatable{
  Habit(
    this.frequency, 
    this.message,
    this.minHour,
    this.maxHour,
    this.minMin,
    this.maxMin,
    this.isActive,
    this.color,
    this.habitType,
    {this.scheduledNotificaitons : const []}
  ) : 
  super();

  int frequency; 
  String message;
  int minHour;
  int maxHour;
  int minMin;
  int maxMin; 
  bool isActive;
  Color color;
  HabitType habitType;
  List<ScheduledNotification> scheduledNotificaitons;

  @override
  List<Object> get props => [
    frequency, 
    message,
    minHour,
    maxHour,
    minMin,
    maxMin,
    isActive,
    color,
    habitType
  ];

  int getTotalScheduledNotifications(){
    int total = 0;

    for(ScheduledNotification scheduledNotificaiton in scheduledNotificaitons){
      if(scheduledNotificaiton.frequency == null){
        total++;
      }else{
        total = total + scheduledNotificaiton.frequency;
      }
    }

    return total;
  }

  static Color getUnusedColor(List<Habit> habits){
    for(Color color in AppColors.habit_colors){
      var colorUsed = false;
      for(Habit habit in habits){
        if(color == habit.color) colorUsed = true;
      }
      if(!colorUsed) return color;
    }

    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

}