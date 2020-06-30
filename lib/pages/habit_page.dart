import 'package:elephant/model/habit.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:elephant/widget/habit_switch.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HabitPage extends StatefulWidget {
  HabitPage(this.habit);

  final Habit habit;

  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {

  Widget _buildSlider(double width){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/mainlogo.png',
              height: 50.0,
              width: 50.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SleekCircularSlider(
              min: 0,
              max: 60,
              innerWidget: (value){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w200,
                        color: AppColors.grey
                      ),
                    ),
                    Container(height: 2.0),
                    Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey
                      ),
                    )
                  ],
                );
              },
              appearance: CircularSliderAppearance(
                size: width - 100,
                startAngle: 287,
                angleRange: 325,
                customColors: CustomSliderColors(
                  trackColor: AppColors.chart_background,
                  progressBarColors: AppColors.habit_colors,
                  dotColor: Colors.blue,
                  hideShadow: true,
                  gradientStartAngle: -90,
                  gradientEndAngle: 90
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5.0,
                  progressBarWidth: 5.0,
                  handlerSize: 10.0,
                )
              ),
              onChange: (double value) {
            })
          )
        ],
      )
    );
  }

  Widget _buildActiveOption(){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Active',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w300,
                color: AppColors.grey
              ),
            ),
          ),
          HabitSwitch(
            color: widget.habit.color,
            isSelected: widget.habit.isActive,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elephant',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 24.0,
            fontWeight: FontWeight.w300
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed:() => Navigator.pop(context, false),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'assets/images/settings.png',
              height: 25.0,
              width: 25.0,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
        child: Column(
          children: <Widget>[
            _buildSlider(width),
            _buildActiveOption()
          ],
        ),
      )
    );
  }
}