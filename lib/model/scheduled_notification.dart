import 'package:equatable/equatable.dart';

class ScheduledNotification extends Equatable{
  ScheduledNotification(
    this.hour, 
    this.min
  ) : 
  super();

  final int hour;
  final int min;

  @override
  List<Object> get props => [
    hour,
    min,
  ];

  ScheduledNotification.fromJson(Map<String, dynamic> json)
    : hour =  json['hour'],
      min = json['min'];

  Map<String, dynamic> toJson() =>
  {
    'hour': hour,
    'min': min,
  }; 
  
}