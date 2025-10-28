import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  final String valueText;
  final String label;
  final IconData icon;
  final Color color;

  const StatChip({
    super.key,
    required this.valueText,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            valueText,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
