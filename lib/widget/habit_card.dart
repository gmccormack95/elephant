import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/uiutil.dart';
import 'package:flutter/material.dart';

import 'habit_switch.dart';

class HabitCard extends StatelessWidget {
  HabitCard({this.habit, this.onSelected, this.onSwitchHabit});

  final Habit habit;
  final Function onSelected;
  final Function onSwitchHabit;

  Widget _buildSwitch(){
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: HabitSwitch(
        color: habit.color,
        isSelected: habit.isActive,
        onSwitch: onSwitchHabit
      ),
    );
  }

  Widget _buildText(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          habit.message,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 18.0,
            fontWeight: FontWeight.w500
          ),
        ),
        Container(
          height: 2.0,
        ),
        Text(
          habit.habitType == HabitType.RANDOM
            ? 'Random'
            : 'Scheduled',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 18.0,
            fontWeight: FontWeight.w300
          ),
        ),
        Container(
          height: 2.0,
        ),
        Visibility(
          visible: habit.habitType == HabitType.RANDOM,
          child: Text(
            '${UIUtil.formatTime(habit.minHour, habit.minMin)} - ${UIUtil.formatTime(habit.maxHour, habit.maxMin)}',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 18.0,
              fontWeight: FontWeight.w300
            ),
          ),
        ),
        Container(
          height: 2.0,
        ),
        Text(
          habit.habitType == HabitType.RANDOM
            ? '${habit.frequency} reminders'
            : '${habit.getTotalScheduledNotifications()} reminders',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 18.0,
            fontWeight: FontWeight.w300
          ),
        ),
      ],
    );
  }

  Widget _buildEdit(){
    return Expanded(
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          alignment: Alignment.bottomRight,
          child: Text(
            'Edit',
            style: TextStyle(
              color: habit.color,
              fontSize: 18.0,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 20.0, left: 2.0, right: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildSwitch(),
            _buildText(),
            _buildEdit()
          ],
        )
      )
    );
  }
}