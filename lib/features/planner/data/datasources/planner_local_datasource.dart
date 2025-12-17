import '../models/plan_model.dart';

abstract class PlannerLocalDataSource {
  Future<List<PlanModel>> getPlansByDate(DateTime date);

  Future<PlanModel> addPlanAtTime(
    DateTime day, {
    required int hour,
    required int minute,
    required String title,
    int difficulty = 1, // 1..5
  });
}

/// In-memory store for the fake datasource
final Map<String, List<PlanModel>> _mem = {};

String _keyOf(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

int _clampDifficulty(int v) {
  if (v < 1) return 1;
  if (v > 5) return 5;
  return v;
}

class PlannerLocalDataSourceFake implements PlannerLocalDataSource {
  @override
  Future<List<PlanModel>> getPlansByDate(DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    final key = _keyOf(day);

    _mem.putIfAbsent(key, () {
      final items = <({int h, int m, String title, int difficulty})>[
        (h: 8, m: 0, title: 'Strength Training', difficulty: 4),
        (h: 9, m: 0, title: 'Review Notes', difficulty: 2),
        (h: 10, m: 30, title: 'Attend Sport Class', difficulty: 3),
        (h: 13, m: 0, title: 'Attend Theory Class', difficulty: 3),
        (h: 14, m: 0, title: 'Read Books', difficulty: 2),
        (h: 14, m: 45, title: 'Excersicing 45-min', difficulty: 4),
        (h: 15, m: 30, title: 'Cleaning Rooms', difficulty: 2),
      ];

      return List.generate(items.length, (i) {
        final s = items[i];
        final start =
            DateTime(day.year, day.month, day.day, s.h, s.m);

        return PlanModel(
          id: '${day.toIso8601String()}-$i',
          date: day,
          title: s.title,
          note: null,
          done: false,
          startAt: start,
          difficulty: _clampDifficulty(s.difficulty),
        );
      });
    });

    final list = List<PlanModel>.from(_mem[key] ?? const []);
    list.sort((a, b) {
      final ta =
          a.startAt ?? DateTime(day.year, day.month, day.day);
      final tb =
          b.startAt ?? DateTime(day.year, day.month, day.day);
      return ta.compareTo(tb);
    });

    return list;
  }

  @override
  Future<PlanModel> addPlanAtTime(
    DateTime day, {
    required int hour,
    required int minute,
    required String title,
    int difficulty = 1,
  }) async {
    final d = DateTime(day.year, day.month, day.day);
    final key = _keyOf(d);

    _mem.putIfAbsent(key, () => []);

    final start =
        DateTime(d.year, d.month, d.day, hour, minute);

    final model = PlanModel(
      id: '${d.toIso8601String()}-${DateTime.now().microsecondsSinceEpoch}',
      date: d,
      title: title,
      note: null,
      done: false,
      startAt: start,
      difficulty: _clampDifficulty(difficulty),
    );

    _mem[key]!.add(model);
    return model;
  }
}
