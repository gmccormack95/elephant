import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:Elephant/bloc/habit_event.dart';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:Elephant/util/app_colors.dart';
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
  var scheduledHour = 12;
  var scheduledMin = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          var habit = habits[widget.index];

          return AlertDialog(
            title: Text(
              'Set time',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
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
              ]
            ),
            actions: <Widget>[
              Visibility(
                visible: widget.scheduleIndex != null && widget.schedule != null,
                child: FlatButton(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: AppColors.grey
                    ),
                  ),
                  onPressed: () {
                    List<ScheduledNotification> list = List.from(habit.scheduledNotificaitons);

                    list.removeAt(widget.scheduleIndex);
                    habit.scheduledNotificaitons = list;
                    context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                    Navigator.of(context).pop();
                  },
                ),
              ),
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
                opacity: 1.0,
                duration: Duration(milliseconds: 350),
                child: IgnorePointer(
                  ignoring: false,
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
                        list.add(ScheduledNotification(scheduledHour, scheduledMin));
                      }else{
                        list.remove(widget.scheduleIndex);
                        list.insert(widget.scheduleIndex, ScheduledNotification(scheduledHour, scheduledMin));
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