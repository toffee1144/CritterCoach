import '../entities/plan.dart';

abstract class PlannerRepository {

  Future<List<Plan>> getPlansByDate(DateTime date);
  
  Future<Plan> addPlanAtTime(
    DateTime day,
    int hour,
    int minute,
    String title, {
    int difficulty,
  });
}