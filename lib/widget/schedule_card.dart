import 'package:elephant/model/scheduled_notification.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:elephant/util/uiutil.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  ScheduleCard(this.schedule, {this.onSelected});

  final ScheduledNotification schedule;
  final Function onSelected;

  Widget _buildText(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Starts',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              Text(
                '${UIUtil.formatTime(schedule.hour, schedule.min)}',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                'Every',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              Text(
                schedule.repeat == null 
                ? 'No repeat'
                : '${schedule.repeat} mins',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300
                ),
              ),
            ]
          ),
        ),
        Opacity(
          opacity: schedule.frequency == null ? 0.0 : 1.0,
          child: Column(
            children: <Widget>[
              Text(
                'Frequency',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              Text(
                '${schedule.frequency}',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
        )
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
              color: AppColors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.only(bottom: 20.0, left: 2.0, right: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildText(),
          _buildEdit()
        ],
      )
    );
  }
}