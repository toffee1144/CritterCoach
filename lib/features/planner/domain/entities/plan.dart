class Plan {
  final String id;
  final DateTime date; // day bucket (00:00)
  final String title;
  final String? note;
  final bool done;
  final DateTime? startAt; // exact time for UI
  final int difficulty; // 1..5

  const Plan({
    required this.id,
    required this.date,
    required this.title,
    this.note,
    required this.done,
    this.startAt,
    this.difficulty = 1,
  });
}
