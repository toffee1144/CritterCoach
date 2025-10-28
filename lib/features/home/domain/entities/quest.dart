// domain/entities/quest.dart

enum ItemType { habit, task }
extension ItemTypeLabel on ItemType {
  String get label => this == ItemType.habit ? 'habit' : 'task';
}

class Quest {
  final String id;
  final String title;
  final double progress;
  final bool completed;
  final ItemType itemType; // ✅ required

  const Quest({
    required this.id,
    required this.title,
    required this.progress,
    required this.completed,
    required this.itemType,
  });
}
