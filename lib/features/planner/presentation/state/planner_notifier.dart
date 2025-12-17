import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../domain/usecases/get_plans_for_date.dart';
import '../../domain/usecases/add_plan_at_time.dart';
import 'planner_state.dart';

class PlannerNotifier extends ChangeNotifier {
  static const int range = 10; // -10 .. +10
  static const int totalTabs = range * 2 + 1;

  final GetPlansForDate getPlansForDate;
  final AddPlanAtTime addPlanAtTime;

  PlannerNotifier({
    required this.getPlansForDate,
    required this.addPlanAtTime,
  });

  PlannerState _state = const PlannerInitial();
  PlannerState get state => _state;

  int currentTabIndex = range;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime dateForTab(int tab) {
    final offset = tab - range;
    return _today.add(Duration(days: offset));
  }

  Future<void> loadForTab(int tabIndex) async {
    currentTabIndex = tabIndex;
    final date = dateForTab(tabIndex);

    _state = const PlannerLoading();
    notifyListeners();

    try {
      final plans = await getPlansForDate(date);
      _state = PlannerLoaded(date: date, plans: plans);
    } catch (e) {
      _state = PlannerError(e.toString());
    }

    notifyListeners();
  }

  Future<void> addAtWithTitle(
    int hour,
    int minute,
    String title,
    int difficulty,
  ) async {
    final day = dateForTab(currentTabIndex);

    try {
      await addPlanAtTime(
        day,
        hour,
        minute,
        title,
        difficulty: difficulty,
      );
      await loadForTab(currentTabIndex);
    } catch (e) {
      _state = PlannerError(e.toString());
      notifyListeners();
    }
  }

  Future<void> addFromPicker(
    TimeOfDay t,
    String title,
    int difficulty,
  ) =>
      addAtWithTitle(t.hour, t.minute, title, difficulty);
}
