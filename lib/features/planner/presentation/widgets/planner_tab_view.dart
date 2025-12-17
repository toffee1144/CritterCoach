import 'package:flutter/material.dart';
import '../../domain/entities/plan.dart';
class PlannerTabView extends StatelessWidget {
final List<Plan> plans;

const PlannerTabView({
super.key,
required this.plans,
});

@override
Widget build(BuildContext context) {
return ListView.separated(
padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
itemCount: plans.length,
separatorBuilder: (_, __) => const SizedBox(height: 12),
itemBuilder: (context, i) {
final p = plans[i];

    final timeText = _formatTime(p.startAt);
    final diff = p.difficulty.clamp(1, 5);
    final c = Theme.of(context).colorScheme.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 92),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  timeText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      p.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (idx) {
                        final filled = idx < diff;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.bolt,
                            size: 18,
                            color: filled ? c : c.withOpacity(0.20),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
}
String _formatTime(DateTime? dt) {
if (dt == null) return '';
final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
final mm = dt.minute.toString().padLeft(2, '0');
final ap = dt.hour >= 12 ? 'PM' : 'AM';
return '${h12.toString().padLeft(2, '0')}:$mm $ap';
}
}

