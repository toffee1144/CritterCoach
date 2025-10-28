import 'package:flutter/material.dart';
import '../../../domain/entities/dashboard.dart';
import '../../../../../core/ui/app_colors.dart';

class DailyQuestsPanel extends StatelessWidget {
  final Dashboard dashboard;
  final VoidCallback onDailyQuests;
  final VoidCallback onHabitReminder;

  const DailyQuestsPanel({
    super.key,
    required this.dashboard,
    required this.onDailyQuests,
    required this.onHabitReminder,
  });

  @override
  Widget build(BuildContext context) {
    final completed = dashboard.completedCount;
    final total = dashboard.quests.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Padding( // ⬅️ removed white card background
      padding: const EdgeInsets.all(0), // adjust from parent if needed
      child: Column(
        children: [
          // Header kuning + progress
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD24D),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x66C08B00), blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.today_rounded, size: 18, color: Colors.black87),
                    const SizedBox(width: 8),
                    const Text(
                      'Today Daily Quests',
                      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      '$completed of $total completed',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress.clamp(0, 1),
                    backgroundColor: const Color(0x33FFFFFF),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB800)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    shadowColor: const Color(0x66FF8A00),
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onDailyQuests,
                  child: const Text('Daily Quests', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    shadowColor: const Color(0x663E75FF),
                    backgroundColor: const Color(0xFF3E75FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onHabitReminder,
                  child: const Text('Habit Reminder', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
