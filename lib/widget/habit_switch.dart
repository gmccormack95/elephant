import 'package:flutter/material.dart';

class HabitSwitch extends StatelessWidget {
  HabitSwitch({
    this.color, 
    this.onSwitch, 
    this.isSelected : false,
    this.height : 30.0,
    this.width : 30.0
  });

  final Color color;
  final Function onSwitch;
  final bool isSelected;
  final double height;
  final double width;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSwitch,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
            ? color
            : Colors.white,
          shape: BoxShape.circle,
          border: isSelected 
            ? null
            : Border.all(
            color: Colors.grey,
            width: 2.0
          )
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}