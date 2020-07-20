import 'package:elephant/bloc/habit_bloc.dart';
import 'package:elephant/bloc/habit_event.dart';
import 'package:elephant/model/habit.dart';
import 'package:elephant/model/habit_type.dart';
import 'package:elephant/pages/habit_page.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:elephant/widget/habit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../util/app_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(275.0, 275.0);
  List<CircularStackEntry> data = List();
  int totalHabits = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HabitBloc>(context).add(LoadHabits());
  }

  _generateData(List<Habit> habits){
    data.clear();
    totalHabits = 0;
    for(Habit habit in habits){
      if(habit.isActive){
        var stackEntry = CircularStackEntry([
          CircularSegmentEntry((habit.frequency/60) * 100, habit.color),
          CircularSegmentEntry(100 - ((habit.frequency/60) * 100), AppColors.chart_background)
        ]);
        totalHabits = totalHabits + habit.frequency;
        data.add(stackEntry);
      }      
    }

    if(data.isEmpty){
      var stackEntry = CircularStackEntry([
        CircularSegmentEntry(100, AppColors.chart_background)
      ]);
      data.add(stackEntry);
    }
  }

  _updateUI(List<Habit> habits){
    _generateData(habits);
    if(_chartKey.currentState != null) _chartKey.currentState.updateData(data);
  }

  Widget _buildTotalChart(double width){
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: width,
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/mainlogo.png',
              height: 50.0,
              width: 50.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SleekCircularSlider(
              min: 0,
              max: 60,
              innerWidget: (value){
                return Container();
              },
              initialValue: 60.0,
              appearance: CircularSliderAppearance(
                animationEnabled: false,
                size: width,
                startAngle: 287,
                angleRange: 325,
                customColors: CustomSliderColors(
                  trackColor: AppColors.chart_background,
                  progressBarColors: AppColors.habit_colors,
                  hideShadow: true,
                  gradientStartAngle: -90,
                  gradientEndAngle: 90
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5.0,
                  progressBarWidth: 10.0,
                  handlerSize: 0.0,
                ),
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 60.0),
            height: 240.0,
            alignment: Alignment.center,
            child: AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: data,
              edgeStyle: SegmentEdgeStyle.round,
              chartType: CircularChartType.Radial,
              percentageValues: true,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildActiveList(List<Habit> habits){
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if(habits[index].isActive){
            return HabitCard(
              habit: habits[index],
              onSelected: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitPage(index)),
                );
              },
              onSwitchHabit: (){
                habits[index].isActive = false;
                context.bloc<HabitBloc>().add(UpdateHabits(habits));
              }
            );
          }else{
            return Container();
          }
        },
        childCount: habits.length,
      ),
    );
  }

  Widget _buildInactiveList(List<Habit> habits){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if(index >= habits.length){
            return Container(
              height: 80.0,
            );
          }
          if(!habits[index].isActive){
            return HabitCard(
              habit: habits[index],
              onSelected: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitPage(index)),
                );
              },
              onSwitchHabit: () {
                habits[index].isActive = true;
                context.bloc<HabitBloc>().add(UpdateHabits(habits));
              }
            );
          }else{
            return Container();
          }
        },
        childCount: habits.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
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
      body: BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          _updateUI(habits);
          return Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 4.0, top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Total Habits',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 4.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      '$totalHabits / 60',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w300,
                        color: AppColors.grey
                      ),
                    ),
                  ),
                ),
                _buildTotalChart(275),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey
                      ),
                    ),
                  ),
                ),
                _buildActiveList(habits),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Inactive',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey
                      ),
                    ),
                  ),
                ),
                _buildInactiveList(habits)
              ],
            ),
          );
        }
      ),
      floatingActionButton: BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          return FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 35.0,
            ),
            backgroundColor: AppColors.grey,
            onPressed: () {
              habits.add(Habit(10, 'New Habit', 17, 21, 0, 0, false, AppColors.defaultColors[(habits.length)%AppColors.defaultColors.length], HabitType.RANDOM));
              context.bloc<HabitBloc>().add(UpdateHabits(habits));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HabitPage(habits.length - 1)),
              );
            },
          );
        }
      ),
    );
  }
}