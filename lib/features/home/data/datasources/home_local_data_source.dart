import '../../domain/entities/dashboard.dart';
import '../../domain/entities/quest.dart';

class HomeLocalDataSource {
  Future<Dashboard> fetchDashboardMock() async {
    // simulasi delay
    await Future.delayed(const Duration(milliseconds: 300));
    return Dashboard(
      userName: 'UserName',
      streakDays: 7,
      xp: 12500,
      coins: 250,
      petName: 'Meyo',
      petHint: "Don't forget to hydrate after your workout!",
      quests: const [
        Quest(id: 'q1', title: 'Complete 30-min run', progress: 0.6, completed: false),
        Quest(id: 'q2', title: 'Drink 8 glass of water', progress: 0.3, completed: false),
        Quest(id: 'q3', title: 'Strength training', progress: 1.0, completed: true),
        Quest(id: 'q4', title: 'Strength training', progress: 0.0, completed: false),
        Quest(id: 'q5', title: 'Strength training', progress: 1.0, completed: true),
        Quest(id: 'q6', title: 'Strength training', progress: 0.2, completed: false),
      ],
    );
  }
}
