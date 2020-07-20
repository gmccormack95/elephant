import 'package:elephant/model/habit_type.dart';
import 'package:elephant/model/scheduled_notification.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
}