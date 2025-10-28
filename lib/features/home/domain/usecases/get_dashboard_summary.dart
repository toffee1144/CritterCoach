import '../repositories/home_repository.dart';
import '../entities/dashboard.dart';

class GetDashboardSummary {
  final HomeRepository repo;
  GetDashboardSummary(this.repo);

  Future<Dashboard> call({required int userId, DateTime? date}) {
    return repo.getSummary(userId: userId, date: date);
  }
}
