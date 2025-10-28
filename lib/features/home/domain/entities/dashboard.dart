import 'quest.dart';

class Dashboard {
  final String userName;
  final int streakDays;
  final int xp;
  final int coins;
  final String petName;
  final String petHint; // subtitle seperti “Don’t forget to hydrate…”
  final List<Quest> quests;

  int get completedCount => quests.where((q) => q.completed).length;

  const Dashboard({
    required this.userName,
    required this.streakDays,
    required this.xp,
    required this.coins,
    required this.petName,
    required this.petHint,
    required this.quests,
  });
}
