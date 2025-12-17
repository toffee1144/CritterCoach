import '../../domain/entities/plan.dart';
import '../../domain/repositories/planner_repository.dart';
import '../datasources/planner_local_datasource.dart';

class PlannerRepositoryImpl implements PlannerRepository {
  final PlannerLocalDataSource local;

  PlannerRepositoryImpl(this.local);

  @override
  Future<List<Plan>> getPlansByDate(DateTime date) =>
      local.getPlansByDate(date);

  @override
  Future<Plan> addPlanAtTime(
    DateTime day,
    int hour,
    int minute,
    String title, {
    int difficulty = 1,
  }) {
    return local.addPlanAtTime(
      day,
      hour: hour,
      minute: minute,
      title: title,
      difficulty: difficulty,
    );
  }
}
