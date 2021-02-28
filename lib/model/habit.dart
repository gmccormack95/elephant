import 'dart:convert';

import 'package:Elephant/main.dart';
import 'package:Elephant/model/elephant_dart.dart';
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
    this.days,
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
  List<ElephantDay> days;
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
    days,
    habitType
  ];

  int getTotalScheduledNotifications(){
    return scheduledNotificaitons.length;
  }

  static var defaultDays = [
    ElephantDay('M', false),
    ElephantDay('T', false),
    ElephantDay('W', false),
    ElephantDay('T', false),
    ElephantDay('F', false),
    ElephantDay('S', false),
    ElephantDay('S', false),
  ];

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

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<ScheduledNotification> getScheduledNotifications(String jsonString){
    Iterable l = json.decode(jsonString);
    return List<ScheduledNotification>.from(l.map((model)=> ScheduledNotification.fromJson(model)));
  }

  static List<ElephantDay> getDays(String jsonString){
    Iterable l = json.decode(jsonString);
    return List<ElephantDay>.from(l.map((model)=> ElephantDay.fromJson(model)));
  }

  Habit.fromJson(Map<String, dynamic> json)
    : frequency =  json['frequency'],
      message = json['message'],
      minHour = json['minHour'],
      maxHour = json['maxHour'],
      minMin = json['minMin'],
      maxMin = json['maxMin'],
      isActive = json['isActive'],
      color = fromHex(json['color']),
      habitType = json['habitType'] == 'HabitType.RANDOM' ? HabitType.RANDOM : HabitType.SCHEDULED,
      days = getDays(json['days']),
      scheduledNotificaitons = getScheduledNotifications(json['scheduledNotificaitons']);

  Map<String, dynamic> toJson() =>
  {
    'frequency': frequency,
    'message': message,
    'minHour': minHour,
    'maxHour': maxHour,
    'minMin': minMin,
    'maxMin': maxMin,
    'isActive': isActive,
    'color': '${color.value.toRadixString(16)}',
    'habitType': habitType.toString(),
    'days': jsonEncode(days.map((e) => e.toJson()).toList()),
    'scheduledNotificaitons': jsonEncode(scheduledNotificaitons.map((e) => e.toJson()).toList())
  }; 

}