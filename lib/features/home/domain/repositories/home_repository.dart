import '../entities/dashboard.dart';

abstract class HomeRepository {
  Future<Dashboard> getSummary({
    required int userId,
    DateTime? date, // default today jika null
  });
}
