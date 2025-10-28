import 'package:flutter/material.dart';
import '../../../../../core/ui/app_colors.dart';

enum StreakChipVariant { blue, red }

class StreakChip extends StatelessWidget {
  final int days;
  final StreakChipVariant variant;
  const StreakChip({super.key, required this.days, this.variant = StreakChipVariant.blue});

  @override
  Widget build(BuildContext context) {
    final bool isRed = variant == StreakChipVariant.red;
    final Color bg = isRed ? const Color(0xFFFFE5E0) : AppColors.softBlue;
    final Color fg = isRed ? const Color(0xFFE53935) : const Color(0xFF1F3AA6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, size: 16, color: isRed ? Colors.orange : fg),
          const SizedBox(width: 6),
          Text('${days}-Days Streak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}
