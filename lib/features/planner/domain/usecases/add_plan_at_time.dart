import '../repositories/planner_repository.dart';
import '../entities/plan.dart';

class AddPlanAtTime {
  
  final PlannerRepository repo;
  AddPlanAtTime(this.repo);

  Future<Plan> call(DateTime day, int hour, int minute, String title, {int difficulty = 1}) {
    return repo.addPlanAtTime(day, hour, minute, title, difficulty: difficulty);
  }
}