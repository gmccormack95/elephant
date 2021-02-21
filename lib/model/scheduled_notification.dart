import 'package:equatable/equatable.dart';

class ScheduledNotification extends Equatable{
  ScheduledNotification(
    this.hour, 
    this.min,
    this.repeat,
    this.frequency
  ) : 
  super();

  final int hour;
  final int min;
  final int repeat;
  final int frequency;

  @override
  List<Object> get props => [
    hour,
    min,
    repeat,
    frequency
  ];

  ScheduledNotification.fromJson(Map<String, dynamic> json)
    : hour =  json['hour'],
      min = json['min'],
      repeat = json['repeat'],
      frequency = json['frequency'];

  Map<String, dynamic> toJson() =>
  {
    'hour': hour,
    'min': min,
    'repeat': repeat,
    'frequency': frequency,
  }; 
  
}