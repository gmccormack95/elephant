import 'package:Elephant/model/habit.dart';
import 'package:equatable/equatable.dart';

abstract class HabitEvent extends Equatable {
  HabitEvent([List props = const[]]) : super();
}

class LoadHabits extends HabitEvent {
  LoadHabits();

  @override
  List<Object> get props => [];
}

class UpdateHabits extends HabitEvent {
  final List<Habit> habits;

  UpdateHabits(this.habits);

  @override
  List<Object> get props => [habits];
}

class UpdateHabit extends HabitEvent {
  final Habit habit;
  final int index;

  UpdateHabit(this.habit, this.index);

  @override
  List<Object> get props => [habit];
}

class CreateHabit extends HabitEvent {
  CreateHabit();

  @override
  List<Object> get props => [];
}

class DeleteHabit extends HabitEvent {
  final int index;

  DeleteHabit(this.index);

  @override
  List<Object> get props => [index];
}