import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_dashboard_summary.dart';
import '../features/home/presentation/state/home_notifier.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ---- Config dasar ----
  const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://72.60.79.89 ko:5001');

  // ---- External ----
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ---- DataSources ----
  sl.registerLazySingleton<HomeRemoteDataSource>(() =>
      HomeRemoteDataSourceImpl(baseUrl: baseUrl, httpClient: sl()));

  // ---- Repositories ----
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));

  // ---- UseCases ----
  sl.registerFactory(() => GetDashboardSummary(sl()));

  // ---- Notifiers ----
  sl.registerFactory(() => HomeNotifier(sl()));
}
