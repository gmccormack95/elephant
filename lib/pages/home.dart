import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:Elephant/bloc/habit_event.dart';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/settings_constants.dart';
import 'package:Elephant/pages/habit_page.dart';
import 'package:Elephant/util/ad_manager.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/settings.dart';
import 'package:Elephant/widget/delete_card.dart';
import 'package:Elephant/widget/habit_card.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:ui' as ui;
import '../util/app_colors.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(275.0, 275.0);
  final scrollController = ScrollController();
  BannerAd _bannerAd;
  List<CircularStackEntry> data = List();
  int totalHabits = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HabitBloc>(context).add(LoadHabits());
    _requestIOSPermissions();
    _initAds();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  _initAds() async {
    await _initAdMob();
    _bannerAd = BannerAd(
        adUnitId: AdManager.bannerAdUnitId,
        size: AdSize.banner,
    );
    _loadBannerAd();
  }

  Future<void> _initAdMob() async {
    if(await ElephantSettings.getBolean(SETTINGS_SHOW_ADS, true)){
      return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    }
    
    return null;
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void _requestIOSPermissions() {
    FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.
      requestPermissions(
        alert: true,
        badge: true,
        sound: true,
    );
  }

  _generateData(List<Habit> habits){
    data.clear();
    totalHabits = 0;
    for(Habit habit in habits){
      if(habit.isActive){
        var habitTotal = habit.habitType == HabitType.RANDOM ? habit.frequency : habit.getTotalScheduledNotifications();
        
        if(totalHabits + habitTotal <= 60){
          var stackEntry = CircularStackEntry([
            CircularSegmentEntry((habitTotal/60) * 102, habit.color),
            CircularSegmentEntry(100 - ((habitTotal/60) * 100), AppColors.chart_background)
          ]);
          data.add(stackEntry);
          totalHabits = totalHabits + habitTotal;
        }else{
          var stackEntry = CircularStackEntry([
            CircularSegmentEntry(((60 - totalHabits)/60) * 102, habit.color),
            CircularSegmentEntry(100 - (((60 - totalHabits)/60) * 100), AppColors.chart_background)
          ]);
          data.add(stackEntry);
          totalHabits = 60;
        }
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

  _isMaxNotificaitons(List<Habit> habits){
    var total = 0;

    for(Habit habit in habits){
      if(habit.isActive){
        var habitTotal = habit.habitType == HabitType.RANDOM ? habit.frequency : habit.getTotalScheduledNotifications();
        total = total + habitTotal;
      }
    }

    return total >= 60;    
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
          Container(
            margin: EdgeInsets.only(top: 60.0),
            child: Text(
              '$totalHabits / 60',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                color: AppColors.grey
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _buildActiveList(List<Habit> habits){
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if(habits[index].isActive){
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key("Active_${habits[index].hashCode}"),
            onDismissed: (direction) {
              habits.removeAt(index);
              context.bloc<HabitBloc>().add(UpdateHabits(habits));
            },
            background: DeleteCard(),
            child: HabitCard(
              habit: habits[index],
              onSelected: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitPage(index, scrollController)),
                );
              },
              onSwitchHabit: (){
                habits[index].isActive = false;
                context.bloc<HabitBloc>().add(UpdateHabits(habits));
              }
            )
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
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key("Inactive_${habits[index].hashCode}"),
              onDismissed: (direction) {
                habits.removeAt(index);
                context.bloc<HabitBloc>().add(UpdateHabits(habits));
              },
              background: DeleteCard(),
              child: HabitCard(
                habit: habits[index],
                onSelected: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabitPage(index, scrollController))
                  );
                },
                onSwitchHabit: (){
                  habits[index].isActive = true;
                  context.bloc<HabitBloc>().add(UpdateHabits(habits));
                  if(_isMaxNotificaitons(habits)){
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          "You’ve reached the max number of habits.",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        backgroundColor: Colors.blue,
                      )
                    );
                  }
                }
              )
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Image.asset(
                'assets/images/settings.png',
                height: 25.0,
                width: 25.0,
              ),
            )
          )
        ],
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          _updateUI(habits);
          return Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
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
                /*SliverPadding(
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
                ),*/
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.habit_colors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000.0),
                  onTap: () {
                    habits.add(Habit(10, 'New Habit', 17, 21, 0, 0, false, Habit.getUnusedColor(habits), HabitType.RANDOM));
                    context.bloc<HabitBloc>().add(UpdateHabits(habits));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HabitPage(habits.length - 1, scrollController))
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding:EdgeInsets.all(10.0),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect rect) {
                        return LinearGradient(
                          colors: AppColors.habit_colors,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      child: Icon(
                        Icons.add,
                        size: 30.0,
                      )
                    ),
                  ),
                ),
              )
            ),
          );
        }
      ),
    );
  }
}