import '../entities/plan.dart';
import '../repositories/planner_repository.dart';

class GetPlansForDate {
  final PlannerRepository repo;
  GetPlansForDate(this.repo);

  Future<List<Plan>> call(DateTime date) => repo.getPlansByDate(date);
}
