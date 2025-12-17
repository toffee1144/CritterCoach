import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.date,
    required super.title,
    super.note,
    required super.done,
    super.startAt,
    super.difficulty = 1,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    final parsedDate =
        _parseDateTimeFlexible(map['date'] ?? map['plan_date']) ??
            DateTime.now();

    final dayOnly =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    final start =
            _parseDateTimeFlexible(
              map['start_at'] ??
                  map['startAt'] ??
                  map['start_time'] ??
                  map['time'],
              base: dayOnly,
            ) ??
        _buildFromHourMinute(
          map['hour'],
          map['minute'] ?? map['min'],
          dayOnly,
        );

    final isDone =
        map['done'] == true || map['done'] == 1 || map['done'] == '1';

    final diffRaw = map['difficulty'];
    final diff = int.tryParse((diffRaw ?? 1).toString()) ?? 1;
    final diffClamped = diff < 1 ? 1 : (diff > 5 ? 5 : diff);

    return PlanModel(
      id: (map['id'] ?? '').toString(),
      date: dayOnly,
      title: (map['title'] ?? '').toString(),
      note: map['note']?.toString(),
      done: isDone,
      startAt: start,
      difficulty: diffClamped,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': DateTime(date.year, date.month, date.day)
            .toIso8601String(),
        'title': title,
        'note': note,
        'done': done ? 1 : 0,
        if (startAt != null)
          'start_at': startAt!.toIso8601String(),
        'difficulty': difficulty,
      };

  static DateTime? _parseDateTimeFlexible(
    dynamic v, {
    DateTime? base,
  }) {
    if (v == null) return null;

    if (v is num) {
      final n = v.toInt();
      final isMillis = n.abs() >= 1000000000000;
      return DateTime.fromMillisecondsSinceEpoch(
        isMillis ? n : n * 1000,
      );
    }

    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return null;

      try {
        return DateTime.parse(
          s.contains('T') ? s : s.replaceFirst(' ', 'T'),
        );
      } catch (_) {}

      // "08:00" / "08:00:00" / "08:00 AM" / "08:00:00 PM"
      final re = RegExp(
        r'^(\d{1,2}):(\d{2})(?::(\d{2}))?\s*([AaPp][Mm])?$',
      );
      final m = re.firstMatch(s);

      if (m != null) {
        var h = int.parse(m.group(1)!);
        final min = int.parse(m.group(2)!);
        final ap = (m.group(4) ?? '').toUpperCase();

        if (ap == 'PM' && h < 12) h += 12;
        if (ap == 'AM' && h == 12) h = 0;

        final b = base ?? DateTime.now();
        return DateTime(b.year, b.month, b.day, h, min);
      }
    }

    return null;
  }

  static DateTime? _buildFromHourMinute(
    dynamic hour,
    dynamic minute,
    DateTime day,
  ) {
    if (hour == null) return null;

    final h = int.tryParse(hour.toString());
    final m = int.tryParse((minute ?? 0).toString());

    if (h == null || m == null) return null;

    return DateTime(day.year, day.month, day.day, h, m);
  }
}
