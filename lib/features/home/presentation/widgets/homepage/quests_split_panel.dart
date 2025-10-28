import 'package:flutter/material.dart';
import '../../../domain/entities/quest.dart';
import '../../../../../core/ui/app_colors.dart';
import 'quest_card.dart';

class QuestsSplitPanel extends StatelessWidget {
  final List<Quest> quests; // mixed list: tasks + habits
  const QuestsSplitPanel({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    final tasks = quests.where((q) => q.itemType == ItemType.task).toList();
    final habits = quests.where((q) => q.itemType == ItemType.habit).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT: TASKS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ...List.generate(tasks.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: QuestCard(quest: tasks[i]),
                  )),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // RIGHT: HABITS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ...List.generate(habits.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: QuestCard(quest: habits[i]),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _PillHeader extends StatelessWidget {
  final String text;
  final Color start;
  final Color end;
  const _PillHeader({
    required this.text,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [start, end]),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
