import 'package:elephant/model/habit.dart';
import 'package:elephant/model/habit_type.dart';
import 'package:elephant/pages/habit_page.dart';
import 'package:elephant/util/app_colors.dart';
import 'package:elephant/widget/habit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(250.0, 250.0);
  List<CircularStackEntry> data = List();
  int totalHabits = 0;

  var habits = [
    Habit(10, 'Drink Water', 9, 17, 0, 0, true, AppColors.habit_colors[0], HabitType.RANDOM),
    Habit(35, 'Be Mindful', 18, 22, 45, 0, false, AppColors.habit_colors[1], HabitType.SCHEDULED),
    Habit(15, 'Sit up Straight', 12, 16, 0, 15, false, AppColors.habit_colors[2], HabitType.RANDOM),
  ];

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  _generateData(){
    data.clear();
    totalHabits = 0;
    for(Habit habit in habits){
      var stackEntry = CircularStackEntry([CircularSegmentEntry(100, AppColors.chart_background)]);

      if(habit.isActive){
        stackEntry = CircularStackEntry([
          CircularSegmentEntry((habit.frequency/60) * 100, habit.color),
          CircularSegmentEntry(100 - ((habit.frequency/60) * 100), AppColors.chart_background)
        ]);
        totalHabits = totalHabits + habit.frequency;
      }

      data.add(stackEntry);      
    }
  }

  _updateUI(){
    _generateData();
    _chartKey.currentState.updateData(data);
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 4.0, top: 40.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Total Habits',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark_blue
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 4.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '$totalHabits / 60',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    color: AppColors.grey
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 250.0,
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
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark_blue
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  if(habits[index].isActive){
                    return HabitCard(
                      habit: habits[index],
                      onSelected: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HabitPage(habits[index])),
                        );
                      },
                      onSwitchHabit: (){
                        setState(() {
                          habits[index].isActive = !habits[index].isActive;
                          _updateUI();
                        });
                      }
                    );
                  }else{
                    return Container();
                  }
                },
                childCount: habits.length,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Inactive',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark_blue
                  ),
                ),
              ),
            ),
            SliverList(
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
                          MaterialPageRoute(builder: (context) => HabitPage(habits[index])),
                        );
                      },
                      onSwitchHabit: () {
                        setState(() {
                          habits[index].isActive = !habits[index].isActive;
                          _updateUI();
                        });
                      }
                    );
                  }else{
                    return Container();
                  }
                },
                childCount: habits.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        backgroundColor: AppColors.grey,
        onPressed: () {},
      ),
    );
  }
}