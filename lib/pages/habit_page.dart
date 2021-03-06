import 'package:Elephant/bloc/habit_bloc.dart';
import 'package:Elephant/bloc/habit_event.dart';
import 'package:Elephant/model/habit.dart';
import 'package:Elephant/model/habit_type.dart';
import 'package:Elephant/model/scheduled_notification.dart';
import 'package:Elephant/model/settings_constants.dart';
import 'package:Elephant/pages/day_selector.dart';
import 'package:Elephant/util/ad_manager.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/settings.dart';
import 'package:Elephant/util/uiutil.dart';
import 'package:Elephant/widget/schedule_alert.dart';
import 'package:Elephant/widget/time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HabitPage extends StatefulWidget {
  HabitPage(this.index, this.homeScrollController);

  final int index;
  final ScrollController homeScrollController;

  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  var pageController = PageController();
  var hideHabitText = false;
  var hideCharacterLimited = true;
  var habitTextController = TextEditingController();
  var loads = 0;
    bool showAds = true;

  @override
  void initState() {
    super.initState();
    _initAds();
    habitTextController.selection = TextSelection.fromPosition(TextPosition(offset: habitTextController.text.length));
  }

  _initAds() async {
    showAds = await ElephantSettings.getBolean(SETTINGS_SHOW_ADS, true);
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

  Widget _buildSlider(double width, List<Habit> habits, Habit habit, BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
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
            child: habit.habitType == HabitType.RANDOM
              ? SleekCircularSlider(
              min: 0,
              max: 60,
              initialValue: habit.frequency.toDouble(),
              innerWidget: (value){
                return AnimatedOpacity(
                  opacity: hideHabitText
                    ? 1.0
                    : 0.0,
                  duration: Duration(milliseconds: 350),
                  child: Column(
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
                  ),
                );
              },
              appearance: CircularSliderAppearance(
                size: width - 100,
                startAngle: 287,
                angleRange: 325,
                animationEnabled: false,
                customColors: CustomSliderColors(
                  trackColor: AppColors.chart_background,
                  progressBarColor: habit.color,
                  dotColor: Colors.blue,
                  hideShadow: true,
                  gradientStartAngle: -90,
                  gradientEndAngle: 90
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5.0,
                  progressBarWidth: 5.0,
                  handlerSize: 10.0,
                ),
              ),
              onChangeStart: (double value){
                setState(() {
                  this.hideHabitText = true;
                });
              },
              onChangeEnd: (double value){
                setState(() {
                  this.hideHabitText = false;
                });
                habit.frequency = value.toInt();
                context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                if(_isMaxNotificaitons(habits)){
                    Get.snackbar(
                      'Max Habits',
                      'You???ve reached the max number of habits.',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  }
              },
              onChange: (double value) {

              }
            )
            : SleekCircularSlider(
              min: 0,
              max: 60,
              initialValue: 0,
              innerWidget: (value){
                return AnimatedOpacity(
                  opacity: hideHabitText
                    ? 1.0
                    : 0.0,
                  duration: Duration(milliseconds: 350),
                  child: Column(
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
                  ),
                );
              },
              appearance: CircularSliderAppearance(
                size: width - 100,
                startAngle: 287,
                angleRange: 325,
                animationEnabled: false,
                customColors: CustomSliderColors(
                  trackColor: AppColors.chart_background,
                  progressBarColor: AppColors.chart_background,
                  dotColor: Colors.transparent,
                  hideShadow: true,
                  gradientStartAngle: -90,
                  gradientEndAngle: 90
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5.0,
                  progressBarWidth: 5.0,
                  handlerSize: 10.0,
                ),
              ),
            )
          ),
          AnimatedOpacity(
            opacity: hideHabitText
              ? 0.0
              : 1.0,
            duration: Duration(milliseconds: 350),
            child: Container(
              height: width - 100,
              width: width - 140,
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: TextField(
                controller: habitTextController,
                onChanged: (text){
                  if(text.length >= 20){
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        this.hideCharacterLimited = true;
                      });
                    });

                    setState(() { this.hideCharacterLimited = false; });
                  }
                },
                maxLength: 20,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onSubmitted: (text){
                  habit.message = text;
                  context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                },
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) {
                  return AnimatedOpacity(
                    opacity: hideCharacterLimited ? 0 : 1.0, 
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      '20 character max limit',
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _buildTypeOption(Habit habit){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Visibility(
            visible: false,
            child: RawMaterialButton(
              elevation: 3.0,
              constraints: BoxConstraints.tightFor(
                width: 35.0,
                height: 35.0,
              ),
              shape: CircleBorder(),
              fillColor: habit.color,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Select a color',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: AppColors.grey
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: habit.color,
                          onColorChanged: (color){
                            habit.color = color;
                            context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: habit.habitType == HabitType.RANDOM
              ? 0
              : 1,
            activeBgColor: habit.color,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey[100],
            inactiveFgColor: Colors.grey[900],
            labels: ['Random', 'Scheduled'],
            onToggle: (index) {
              if(index == 0){
                habit.habitType = HabitType.RANDOM;
                context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeIn);
              }else{
                habit.habitType = HabitType.SCHEDULED;
                context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
                pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeIn);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHabitControls(Habit habit){
    return Flexible(
      child: Container(
        height: habit.habitType == HabitType.RANDOM ? 300 : 600,
        child: PageView(
        controller: pageController,
        physics:new NeverScrollableScrollPhysics(),
        children: <Widget>[
          _buildRandomControls(habit),
          _buildScheduledControls(habit),
        ],
      )
      )
    );
  }

  Widget _buildRandomControls(Habit habit){
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TimerPicker(
            startHour: habit.minHour,
            startMinute: habit.minMin,
            onHourSelected: (hour){
              habit.minHour = hour;
              context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
            },
            onMinuteSelected: (minute){
              habit.minMin = minute;
              context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
            },
          ),
          Text(
            '-',
            style: TextStyle(
              fontSize: 40.0,
              color: AppColors.grey,
              fontWeight: FontWeight.w200
            ),
          ),
          TimerPicker(
            startHour: habit.maxHour,
            startMinute: habit.maxMin,
            onHourSelected: (hour){
              habit.maxHour = hour;
              context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
            },
            onMinuteSelected: (minute){
              habit.maxMin = minute;
              context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
            },
          ),
        ],
      )
    );
  }

  Widget _buildScheduledNotifications(Habit habit){
    return Container(
      margin: EdgeInsets.only(top: habit.scheduledNotificaitons.length == 0 ? 0 : 30.0),
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: habit.scheduledNotificaitons.map((ScheduledNotification notification) {
            return GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ScheduleAlert(widget.index, scheduleIndex: habit.scheduledNotificaitons.indexOf(notification));
                  },
                );
              },
              child: GridTile(
                child: Container(
                  decoration: BoxDecoration(
                    color: habit.color,
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${UIUtil.formatHour(notification.hour)}:${UIUtil.formatMin(notification.min)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget _buildAddScheduledNotifcation(Habit habit){
    return Container(
      margin: EdgeInsets.only(top: habit.scheduledNotificaitons.length == 0 ? 0 : 40.0),
      alignment: Alignment.center,
      child: Material(
        type: MaterialType.transparency, 
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: habit.color, width: 3.0),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(1000.0),
            onTap: (){
              if(habit.habitType == HabitType.RANDOM) return; 

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ScheduleAlert(widget.index);
                },
              );
            },
            child: Padding(
              padding:EdgeInsets.all(10.0),
              child: Icon(
                Icons.add,
                size: 30.0,
                color: habit.color,
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget _buildDaySelector(Habit habit){
    return DaySelector(
      habit.color,
      habit.days,
      onTap: (dayIndex){
        setState(() { 
          habit.days[dayIndex].selected = !habit.days[dayIndex].selected;
          context.bloc<HabitBloc>().add(UpdateHabit(habit, widget.index));
        });
      },
    );
  }

  Widget _buildScheduledControls(Habit habit){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDaySelector(habit),
        _buildScheduledNotifications(habit),
        _buildAddScheduledNotifcation(habit)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elephant App',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 24.0,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
        brightness: Brightness.light,
        centerTitle: true,
        leading: BlocBuilder<HabitBloc, List<Habit>>(
          builder: (context, habits) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed:() {
                widget.homeScrollController.jumpTo(0);
                Navigator.pop(context, false);
              }
            );
          }
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: showAds ? 50 : 0,
        child: AdWidget(
          key: UniqueKey(),
          ad: AdManager.createBannerAd()..load()
        )
      ),
      body: BlocBuilder<HabitBloc, List<Habit>>(
        builder: (context, habits) {
          var habit = habits[widget.index];
          habitTextController.text = habit.message;
          if(loads == 0){
            pageController = PageController(initialPage: habit.habitType == HabitType.RANDOM ? 0 : 1);
          }
          loads++;
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTypeOption(habit),
                _buildSlider(width, habits, habit, context),
                _buildHabitControls(habit),
              ],
            )
          );
        }
      ),
    );
  }
}