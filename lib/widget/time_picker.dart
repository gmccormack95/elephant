import 'package:Elephant/widget/snapping_list_view.dart';
import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/uiutil.dart';

class TimerPicker extends StatefulWidget {
  TimerPicker({this.startHour, this.startMinute, this.onHourSelected, this.onMinuteSelected, this.hideArrows : false});

  final int startHour;
  final int startMinute;
  final Function(int) onHourSelected;
  final Function(int) onMinuteSelected;
  final hours = ["0","1","2","3","4","5","6","7","8","9","10",
    "11","12","13","14","15","16","17","18","19","20","21",
    "22","23","24"];
  final minutes = ["00", "15", "30", "45"];
  final bool hideArrows;

  @override
  _TimerPickerState createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  var hourController = ScrollController();
  var minuteController = ScrollController();

  @override
  void initState() {
    super.initState();
    hourController = ScrollController(initialScrollOffset: 40.0 * widget.startHour);
    minuteController = ScrollController(initialScrollOffset: 40.0 * widget.startMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.0,
      height: widget.hideArrows ? 60.0 : 120.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: !widget.hideArrows,
            child: Image.asset(
              'assets/images/upArrow.png',
              height: 20.0,
              width: 20.0,
            ),
          ),
          Visibility(
            visible: !widget.hideArrows,
            child: Container(
              height: 10.0
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 55.0,
                  child: SnappingListView.builder(
                    scrollDirection: Axis.vertical,
                    itemExtent: 40.0,
                    itemCount: widget.hours.length,
                    controller: hourController,
                    onItemChanged: (index){
                      widget.onHourSelected(int.parse(widget.hours[index]));
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40.0,
                        alignment: Alignment.centerRight,
                        child: Text(
                          UIUtil.formatStringHour(widget.hours[index]),
                          style: TextStyle(
                            fontSize: 40.0,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w200
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w200
                    ),
                  ),
                ),
                Container(
                  height: 40.0,
                  width: 55.0,
                  child: SnappingListView.builder(
                    scrollDirection: Axis.vertical,
                    itemExtent: 40.0,
                    controller: minuteController,
                    onItemChanged: (index){
                      widget.onMinuteSelected(int.parse(widget.minutes[index%4]));
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          UIUtil.formatStringHour(widget.minutes[index%4]),
                          style: TextStyle(
                            fontSize: 40.0,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w200
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !widget.hideArrows,
            child: Container(
              height: 17.0
            )
          ),
          Visibility(
            visible: !widget.hideArrows,
            child: Image.asset(
              'assets/images/downArrow.png',
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}