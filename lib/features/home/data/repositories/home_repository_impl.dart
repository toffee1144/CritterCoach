import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/dashboard.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  HomeRepositoryImpl(this.remote);

  @override
  Future<Dashboard> getSummary({required int userId, DateTime? date}) async {
    final model = await remote.fetchSummary(userId: userId, date: date);
    return model.toEntity();
  }
}
