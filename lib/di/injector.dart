import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/auth_page.dart';
import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_dashboard_summary.dart';
import '../features/home/presentation/state/home_notifier.dart';
import '../features/planner/data/datasources/planner_local_datasource.dart';
import '../features/planner/data/datasources/planner_remote_datasource.dart';
import '../features/planner/data/repositories/planner_repository_impl.dart';
import '../features/planner/domain/repositories/planner_repository.dart';
import '../features/planner/domain/usecases/add_plan_at_time.dart';
import '../features/planner/domain/usecases/get_plans_for_date.dart';
import '../features/planner/presentation/state/planner_notifier.dart';
import '../features/chatbot/data/datasources/chatbot_remote_ds.dart';
import '../features/chatbot/data/datasources/chatbot_remote_ds_impl.dart';
import '../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../features/chatbot/domain/usecases/send_message.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  await sl.reset(dispose: true);

  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://72.60.79.89:5001',
  );

  // Core
  sl.registerLazySingleton<GlobalKey<NavigatorState>>(() => GlobalKey<NavigatorState>());
  sl.registerSingleton<String>(baseUrl, instanceName: 'baseUrl');
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Current user store
  final userStore = CurrentUserStore(prefs);
  await userStore.loadFromPrefs();
  sl.registerSingleton<CurrentUserStore>(userStore);

  // Auth
  sl.registerLazySingleton<AuthApi>(() => AuthApi(
        baseUrl: sl<String>(instanceName: 'baseUrl'),
        client: sl<http.Client>(),
      ));

  // Home feature
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
        baseUrl: sl<String>(instanceName: 'baseUrl'),
        httpClient: sl<http.Client>(),
      ));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<GetDashboardSummary>(() => GetDashboardSummary(sl()));
  sl.registerFactory<HomeNotifier>(() => HomeNotifier(sl()));

  // Planner feature
  sl.registerLazySingleton<PlannerLocalDataSource>(() => PlannerRemoteDataSource(
        baseUrl: sl<String>(instanceName: 'baseUrl'),
        client: sl<http.Client>(),
        userStore: sl<CurrentUserStore>(),
      ));
  sl.registerLazySingleton<PlannerRepository>(() => PlannerRepositoryImpl(sl()));
  sl.registerLazySingleton<GetPlansForDate>(() => GetPlansForDate(sl()));
  sl.registerLazySingleton<AddPlanAtTime>(() => AddPlanAtTime(sl()));
  sl.registerFactory<PlannerNotifier>(() => PlannerNotifier(
        getPlansForDate: sl(),
        addPlanAtTime: sl(),
      ));

  // Chatbot feature
  sl.registerLazySingleton<ChatBotRemoteDataSource>(() => ChatBotRemoteDataSourceImpl(
        baseUrl: sl<String>(instanceName: 'baseUrl'),
        client: sl<http.Client>(),
      ));
  sl.registerLazySingleton<ChatBotRepository>(() => ChatBotRepositoryImpl(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
}
