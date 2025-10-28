import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyQuestsPage extends StatelessWidget {
  const DailyQuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;

      return Container(
        color: const Color(0xFFE9F4FF),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/features/onboarding/vector_wave_blue.svg',
                width: w, fit: BoxFit.cover,
              ),
            ),
            const Align(
              alignment: Alignment(0, -0.82),
              child: Text(
                'Complete Daily\nQuests',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28),
              ),
            ),
            const Align(
              alignment: Alignment(0, -0.62),
              child: Text(
                'Build a habit and track your goals.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.32),
              child: SvgPicture.asset(
                'assets/global/icons/creature.svg',
                width: w * 0.42,
                fit: BoxFit.contain,
                // semanticsLabel: 'Creature', // optional
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.23),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: w * 0.86,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFED7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const _QuestCard(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                percent: 0.5,
                lineHeight: 22,
                animation: true,
                progressColor: const Color(0xFFFFDA27),
                backgroundColor: const Color(0xFFFFF69E),
                barRadius: const Radius.circular(12),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 12),
            const Text('2 / 4', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 16),
        const _QuestRow(icon: Icons.check_circle, iconColor: Color(0xFF09B506), label: 'Daily Quest'),
        const _QuestRow(icon: Icons.directions_run, iconColor: Color(0xFF3380EF), label: '30-min run'),
        _QuestRow.custom(
          leading: SvgPicture.asset('assets/features/onboarding/book_stroke.svg', width: 22, height: 22),
          label: 'Read for 10 min',
        ),
        const _QuestRow(icon: Icons.pedal_bike_rounded, iconColor: Color(0xFF3380EF), label: 'Riding for 30 min'),
      ],
    );
  }
}

class _QuestRow extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget? leading;
  final String label;

  const _QuestRow({super.key, this.icon, this.iconColor, this.leading, required this.label});

  const _QuestRow.custom({super.key, required this.leading, required this.label})
      : icon = null, iconColor = null;

  @override
  Widget build(BuildContext context) {
    final lead = leading ?? Icon(icon, color: iconColor, size: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 28, height: 28, child: Center(child: lead)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
