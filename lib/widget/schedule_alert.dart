import 'package:elephant/bloc/habit_bloc.dart';
import 'package:elephant/bloc/habit_event.dart';
import 'package:elephant/model/habit.dart';
import 'package:elephant/model/scheduled_notification.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'time_picker.dart';

class ScheduleAlert extends StatefulWidget {
  ScheduleAlert(this.index, {this.scheduleIndex, this.schedule});

  final int index;
  final int scheduleIndex;
  final ScheduledNotification schedule;

  @override
  _ScheduleAlertState createState() => _ScheduleAlertState();
}

class _ScheduleAlertState extends State<ScheduleAlert> {
  int repeat;
  int frequency;
  var scheduledHour = 0;
  var scheduledMin = 0;
  var shouldRepeat = false;

  @override
  void initState() {
    super.initState();
    if(widget.schedule != null){
      shouldRepeat = widget.schedule.frequency != null;
      scheduledHour = widget.schedule.hour;
      scheduledMin = widget.schedule.min;
      frequency = widget.schedule.frequency;
      repeat = widget.schedule.repeat; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          var habit = habits[widget.index];
          if(widget.scheduleIndex == null){
            scheduledHour = habit.maxHour;
            scheduledMin = habit.maxMin;
          }

          return AlertDialog(
            title: Text(
              'Schedule a reminder',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: AppColors.grey
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: TimerPicker(
                    startHour: habit.maxHour,
                    startMinute: habit.maxMin,
                    onHourSelected: (hour){
                      setState(() {
                        this.scheduledHour = hour;
                      });
                    },
                    onMinuteSelected: (minute){
                      setState(() {
                        this.scheduledMin = minute;
                      });
                    },
                    hideArrows: false,
                  ),
                ),
                Container(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: shouldRepeat,
                        checkColor: Colors.white,
                        activeColor: habit.color,
                        onChanged: (value){
                          setState(() {
                            this.shouldRepeat = value;
                            if(!shouldRepeat){
                              frequency = null;
                              repeat = null;
                            }
                          });
                        },
                      ),
                    ),
                    Text(
                      '  Repeat',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 10.0,
                ),
                AnimatedOpacity(
                  opacity: shouldRepeat ? 1.0 : 0.3,
                  duration: Duration(milliseconds: 350),
                  child: IgnorePointer(
                    ignoring: !shouldRepeat,
                    child: DropdownButton<int>(
                      items: [
                        DropdownMenuItem(
                          value: 15,
                          child: Text("Every 15 minutes"),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text("Every 30 minutes"),
                        ),
                        DropdownMenuItem(
                          value: 60,
                          child: Text("Every hour"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          repeat = value;
                        });
                      },
                      hint: Text("Every..."),
                      value: repeat,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: shouldRepeat ? 1.0 : 0.3,
                  duration: Duration(milliseconds: 350),
                  child: IgnorePointer(
                    ignoring: !shouldRepeat,
                    child: DropdownButton<int>(
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("1"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("2"),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text("3"),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text("4"),
                        ),
                        DropdownMenuItem(
                          value: 5,
                          child: Text("5"),
                        ),
                        DropdownMenuItem(
                          value: 6,
                          child: Text("6"),
                        ),
                        DropdownMenuItem(
                          value: 7,
                          child: Text("7"),
                        ),
                        DropdownMenuItem(
                          value: 8,
                          child: Text("8"),
                        ),
                        DropdownMenuItem(
                          value: 9,
                          child: Text("9"),
                        ),
                        DropdownMenuItem(
                          value: 10,
                          child: Text("10"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          frequency = value;
                        });
                      },
                      hint: Text("Frequency"),
                      value: frequency,
                    ),
                  ),
                ),
              ]
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.grey
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              AnimatedOpacity(
                opacity: (shouldRepeat && (frequency == null || repeat == null)) ? 0.3 : 1.0,
                duration: Duration(milliseconds: 350),
                child: IgnorePointer(
                  ignoring: (shouldRepeat && (frequency == null || repeat == null)),
                  child: FlatButton(
                    child: Text(
                      'Okay',
                      style: TextStyle(
                        color: AppColors.grey
                      ),
                    ),
                    onPressed: () {
                      List<ScheduledNotification> list = List.from(habit.scheduledNotificaitons);

                      if(widget.scheduleIndex == null){
                        list.add(ScheduledNotification(scheduledHour, scheduledMin, repeat, frequency));
                      }else{
                        list.removeAt(widget.scheduleIndex);
                        list.insert(widget.scheduleIndex, ScheduledNotification(scheduledHour, scheduledMin, repeat, frequency));
                      }
                      
                      habit.scheduledNotificaitons = list;
                      context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}