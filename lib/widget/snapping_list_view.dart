import "package:flutter/widgets.dart";
import "dart:math";

class SnappingListView extends StatefulWidget {
  final Axis scrollDirection;
  final ScrollController controller;

  final IndexedWidgetBuilder itemBuilder;
  final List<Widget> children;
  final int itemCount;

  final double itemExtent;
  final ValueChanged<int> onItemChanged;

  final EdgeInsets padding;

  SnappingListView(
      {this.scrollDirection,
      this.controller,
      @required this.children,
      @required this.itemExtent,
      this.onItemChanged,
      this.padding = const EdgeInsets.all(0.0)})
      : assert(itemExtent > 0),
        itemCount = null,
        itemBuilder = null;

  SnappingListView.builder(
      {this.scrollDirection,
      this.controller,
      @required this.itemBuilder,
      this.itemCount,
      @required this.itemExtent,
      this.onItemChanged,
      this.padding = const EdgeInsets.all(0.0)})
      : assert(itemExtent > 0),
        children = null;

  @override
  createState() => _SnappingListViewState();
}

class _SnappingListViewState extends State<SnappingListView> {
  int _lastItem = 0;

  @override
  Widget build(BuildContext context) {
    final startPadding = widget.scrollDirection == Axis.horizontal
        ? widget.padding.left
        : widget.padding.top;
    final scrollPhysics = SnappingListScrollPhysics(
        mainAxisStartPadding: startPadding, itemExtent: widget.itemExtent);
    final listView = widget.children != null
        ? ListView(
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            children: widget.children,
            itemExtent: widget.itemExtent,
            physics: scrollPhysics,
            padding: widget.padding)
        : ListView.builder(
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            itemBuilder: widget.itemBuilder,
            itemCount: widget.itemCount,
            itemExtent: widget.itemExtent,
            physics: scrollPhysics,
            padding: widget.padding);
    return NotificationListener<ScrollNotification>(
        child: listView,
        onNotification: (notif) {
          if (notif.depth == 0 &&
              widget.onItemChanged != null &&
              notif is ScrollUpdateNotification) {
            final currItem =
                (notif.metrics.pixels - startPadding) ~/ widget.itemExtent;
            if (currItem != _lastItem) {
              _lastItem = currItem;
              widget.onItemChanged(currItem);
            }
          }
          return false;
        });
  }
}

class SnappingListScrollPhysics extends ScrollPhysics {
  final double mainAxisStartPadding;
  final double itemExtent;

  const SnappingListScrollPhysics(
      {ScrollPhysics parent,
      this.mainAxisStartPadding = 0.0,
      @required this.itemExtent})
      : super(parent: parent);

  @override
  SnappingListScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SnappingListScrollPhysics(
        parent: buildParent(ancestor),
        mainAxisStartPadding: mainAxisStartPadding,
        itemExtent: itemExtent);
  }

  double _getItem(ScrollPosition position) {
    return (position.pixels - mainAxisStartPadding) / itemExtent;
  }

  double _getPixels(ScrollPosition position, double item) {
    return min(item * itemExtent, position.maxScrollExtent);
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity)
      item -= 0.5;
    else if (velocity > tolerance.velocity) item += 0.5;
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}