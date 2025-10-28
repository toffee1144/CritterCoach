import '../../domain/entities/dashboard.dart';
import '../../domain/entities/quest.dart';

class SummaryUserModel {
  final int id;
  final String userName;
  final int xp;
  final int coins;

  SummaryUserModel({
    required this.id,
    required this.userName,
    required this.xp,
    required this.coins,
  });

  factory SummaryUserModel.fromJson(Map<String, dynamic> json) {
    final name = (json['username'] ?? json['nickname'] ?? 'User').toString();
    return SummaryUserModel(
      id: _asInt(json['id'] ?? json['user_id']),
      userName: name,
      xp: _asInt(json['xp']),
      coins: _asInt(json['coins']),
    );
  }
}

class SummaryModel {
  final SummaryUserModel user;
  final String date;
  final List<Map<String, dynamic>> questsJson;
  final List<Map<String, dynamic>> habitsJson;

  SummaryModel({
    required this.user,
    required this.date,
    required this.questsJson,
    required this.habitsJson,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      user: SummaryUserModel.fromJson((json['user'] ?? const {}) as Map<String, dynamic>),
      date: (json['date'] ?? '').toString(),
      questsJson: ((json['quests'] ?? const []) as List).cast<Map<String, dynamic>>(),
      habitsJson: ((json['habits'] ?? const []) as List).cast<Map<String, dynamic>>(),
    );
  }

  /// Map ke entity Dashboard (gabungkan quest + habit jadi satu list Quest)
  Dashboard toEntity() {
    final questItems = questsJson.map((m) {
      final id = (m['quest_instance_id'] ?? m['template_id'] ?? m['id']).toString();
      final title = (m['title'] ?? 'Quest').toString();
      final status = (m['status'] ?? 'pending').toString().toLowerCase();

      // Completed flag: true jika status 'completed' atau progress >= 1
      final completedFromStatus = status == 'completed' || status == 'done';
      final progressRaw = m['progress'];
      final progressParsed = progressRaw == null ? null : _asDouble(progressRaw);
      final progress = progressParsed != null
          ? progressParsed.clamp(0.0, 1.0)
          : (completedFromStatus ? 1.0 : 0.0);
      final completed = completedFromStatus || progress >= 1.0;

      return Quest(
        id: id,
        title: title,
        progress: progress,
        completed: completed,
        itemType: ItemType.task, // ✅ quests dianggap "task"
      );
    });

    final habitItems = habitsJson.map((m) {
      final id = (m['habit_log_id'] ?? m['habit_id'] ?? m['id']).toString();
      final title = (m['name'] ?? m['title'] ?? 'Habit').toString();

      final target = _asInt(m['daily_target'], fallback: 1);
      final done = _asInt(m['count_done'], fallback: 0);
      final status = (m['status'] ?? 'pending').toString().toLowerCase();

      final completedFromStatus = status == 'completed' || status == 'done';
      final ratio = target > 0 ? (done / target) : 0.0;
      final progress = (completedFromStatus ? 1.0 : ratio).clamp(0.0, 1.0);
      final completed = completedFromStatus || progress >= 1.0;

      return Quest(
        id: 'h_$id',
        title: title,
        progress: progress,
        completed: completed,
        itemType: ItemType.habit, // ✅ habits dianggap "habit"
      );
    });

    final all = <Quest>[...questItems, ...habitItems];

    return Dashboard(
      userName: user.userName,
      streakDays: 0, // TODO: isi dari backend kalau tersedia
      xp: user.xp,
      coins: user.coins,
      petName: 'Meyo',
      petHint: "Don't forget to hydrate after your workout!",
      quests: all,
    );
  }
}

/// ---------- Parsers kecil & aman ----------
int _asInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.round();
  final s = v.toString();
  return int.tryParse(s) ?? fallback;
}

double _asDouble(dynamic v, {double fallback = 0.0}) {
  if (v == null) return fallback;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  final s = v.toString();
  return double.tryParse(s) ?? fallback;
}
