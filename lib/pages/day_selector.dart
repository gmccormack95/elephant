import 'package:Elephant/model/elephant_dart.dart';
import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  DaySelector(this.color, this.days, {this.onTap});

  final Color color;
  final List<ElephantDay> days;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DayWidget(days[0], color, onTap, 0),
        DayWidget(days[1], color, onTap, 1),
        DayWidget(days[2], color, onTap, 2),
        DayWidget(days[3], color, onTap, 3),
        DayWidget(days[4], color, onTap, 4),
        DayWidget(days[5], color, onTap, 5),
        DayWidget(days[6], color, onTap, 6),
      ],
    );
  }

}

class DayWidget extends StatelessWidget {
  DayWidget(this.day, this.color, this.onTap, this.index);

  final ElephantDay day;
  final Color color;
  final Function(int) onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap(index);
      },
      child: Container(
        height: 35.0,
        width: 35.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: day.selected ? color : Colors.white,
          border: Border.all(
            color: color,
            width: 1.5,
            style: BorderStyle.solid
          )
        ),
        alignment: Alignment.center,
        child: Text(
          day.name,
          style: TextStyle(
            color: day.selected ? Colors.white : color,
          ),
        ),
      )
    );
  }
}