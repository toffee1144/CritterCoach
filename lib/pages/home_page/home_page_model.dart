import '/components/done_habit_tile_widget.dart';
import '/components/done_task_tile_widget.dart';
import '/components/habit_tile_widget.dart';
import '/components/task_tile_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  List<dynamic> task = [];
  void addToTask(dynamic item) => task.add(item);
  void removeFromTask(dynamic item) => task.remove(item);
  void removeAtIndexFromTask(int index) => task.removeAt(index);
  void insertAtIndexInTask(int index, dynamic item) => task.insert(index, item);
  void updateTaskAtIndex(int index, Function(dynamic) updateFn) =>
      task[index] = updateFn(task[index]);

  List<dynamic> habit = [];
  void addToHabit(dynamic item) => habit.add(item);
  void removeFromHabit(dynamic item) => habit.remove(item);
  void removeAtIndexFromHabit(int index) => habit.removeAt(index);
  void insertAtIndexInHabit(int index, dynamic item) =>
      habit.insert(index, item);
  void updateHabitAtIndex(int index, Function(dynamic) updateFn) =>
      habit[index] = updateFn(habit[index]);

  int? completedCount;

  ///  State fields for stateful widgets in this page.

  // Models for TaskTile dynamic component.
  late FlutterFlowDynamicModels<TaskTileModel> taskTileModels;
  // Models for HabitTile dynamic component.
  late FlutterFlowDynamicModels<HabitTileModel> habitTileModels;
  // Model for DoneTaskTile component.
  late DoneTaskTileModel doneTaskTileModel;
  // Model for DoneHabitTile component.
  late DoneHabitTileModel doneHabitTileModel;

  @override
  void initState(BuildContext context) {
    taskTileModels = FlutterFlowDynamicModels(() => TaskTileModel());
    habitTileModels = FlutterFlowDynamicModels(() => HabitTileModel());
    doneTaskTileModel = createModel(context, () => DoneTaskTileModel());
    doneHabitTileModel = createModel(context, () => DoneHabitTileModel());
  }

  @override
  void dispose() {
    taskTileModels.dispose();
    habitTileModels.dispose();
    doneTaskTileModel.dispose();
    doneHabitTileModel.dispose();
  }
}
