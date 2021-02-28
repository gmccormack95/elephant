import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ElephantDay {
  ElephantDay(this.name, this.selected);

  final String name;
  bool selected;

  @override
  List<Object> get props => [
    name,
    selected
  ];

  ElephantDay.fromJson(Map<String, dynamic> json)
    : name =  json['name'],
      selected = json['selected'];

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'selected': selected
  }; 
}