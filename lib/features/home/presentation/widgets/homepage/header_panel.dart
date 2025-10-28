import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/dashboard.dart';
import '../../state/home_notifier.dart';
import 'stat_chip.dart';
import 'streak_chip.dart';

class HeaderPanel extends StatefulWidget {
  const HeaderPanel({
    super.key,
    required this.userId,
    this.date, // optional: jika null pakai "today"
  });

  final int userId;
  final DateTime? date;

  @override
  State<HeaderPanel> createState() => _HeaderPanelState();
}

class _HeaderPanelState extends State<HeaderPanel> {
  // ---------- Tweak knobs (defaults mirror the mock) ----------
  double circleScale = 0.75;      // % of available width
  double creatureScale = 0.70;    // % of circle diameter

  // Use *percent* of circle diameter for responsive spacing (not px):
  double nameBottomPct = 0.20;        // 20% of circle
  double bubbleBottomPct = 0.05;       // 5% of circle (can be slightly negative)
  double creatureYOffsetPct = -0.12;   // -12% (up)

  double bubbleElevation = 8;      // material elevation
  double circleLightness = 0.92;   // 0.85–0.98 (lightness knob)

  bool _bootstrapped = false;

  void _reset() {
    setState(() {
      circleScale = 0.75;
      creatureScale = 0.70;
      nameBottomPct = 0.20;
      bubbleBottomPct = 0.05;
      creatureYOffsetPct = -0.12;
      bubbleElevation = 8;
      circleLightness = 0.92;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bootstrapped) {
      _bootstrapped = true;
      // trigger load once when widget appears
      final vm = context.read<HomeNotifier>();
      vm.load(userId: widget.userId, date: widget.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeNotifier>();
    final bool loading = vm.loading;
    final String? error = vm.error;
    final Dashboard? d0 = vm.dashboard;

    // Fallbacks untuk state awal/loading
    final d = d0 ??
        Dashboard(
          userName: 'Loading…',
          streakDays: 0,
          xp: 0,
          coins: 0,
          petName: 'Meyo',
          petHint: 'Fetching tips…',
          quests: const [],
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Column(
        children: [
          // Top row: name + chips + tune button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: username + streak
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            d.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1F1F1F),
                                ),
                          ),
                        ),
                        if (loading)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StreakChip(
                      days: d.streakDays,
                      variant: StreakChipVariant.red,
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Error: $error',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),

              // Right: XP & Coins stacked vertically + tune button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatChip(
                        valueText: d.xp.toString(),
                        label: 'XP',
                        color: const Color(0xFF2D74FF),
                        icon: Icons.bolt_rounded,
                      ),
                      const SizedBox(height: 8),
                      StatChip(
                        valueText: d.coins.toString(),
                        label: 'Coins',
                        color: const Color(0xFFFF9F1C),
                        icon: Icons.monetization_on_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Tune header',
                    icon: const Icon(Icons.tune_rounded, size: 20),
                    onPressed: () => _openTweaks(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Creature + circle + name + bubble
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final circle = (w * circleScale).clamp(160.0, 460.0);
              final pet = (circle * creatureScale).clamp(120.0, 420.0);

              // Convert percentage knobs -> px (responsive)
              final nameBottomPx = circle * nameBottomPct;
              final bubbleBottomPx = circle * bubbleBottomPct;
              final creatureYOffsetPx = circle * creatureYOffsetPct;

              // Map lightness to an ARGB grey-blue
              final l = (circleLightness.clamp(0.85, 0.98) * 255).round();
              final circleColor =
                  Color.fromARGB(255, l, l, (l + 5).clamp(0, 255));

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Big soft circle
                  Container(
                    width: circle,
                    height: circle,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                  ),

                  // Creature SVG
                  Transform.translate(
                    offset: Offset(0, creatureYOffsetPx),
                    child: SvgPicture.asset(
                      'assets/global/icons/creature_2.svg',
                      width: pet,
                      height: pet,
                      semanticsLabel: 'Creature',
                    ),
                  ),

                  // Pet name
                  Positioned(
                    bottom: nameBottomPx,
                    child: Text(
                      d.petName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: 0.2,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Hint bubble
                  Positioned(
                    bottom: bubbleBottomPx,
                    child: Material(
                      elevation: bubbleElevation,
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          d.petHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _openTweaks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            Widget slider({
              required String label,
              required double value,
              required double min,
              required double max,
              int? divisions,
              required ValueChanged<double> onChanged,
              String? suffix,
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$label: ${value.toStringAsFixed(2)}${suffix ?? ''}'),
                  Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: (v) {
                      setLocal(() => onChanged(v));
                      setState(() {}); // rebuild main view live
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }

            return AlertDialog(
              title: const Text('Header Tweaks'),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Scales (relative)
                      slider(
                        label: 'Circle scale (of width)',
                        value: circleScale,
                        min: 0.55,
                        max: 0.95,
                        divisions: 40,
                        onChanged: (v) => circleScale = v,
                      ),
                      slider(
                        label: 'Creature scale (of circle)',
                        value: creatureScale,
                        min: 0.50,
                        max: 0.80,
                        divisions: 30,
                        onChanged: (v) => creatureScale = v,
                      ),

                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Percent-based offsets
                      slider(
                        label: 'Name bottom (% of circle)',
                        value: nameBottomPct,
                        min: 0.05,
                        max: 0.40,
                        divisions: 35,
                        onChanged: (v) => nameBottomPct = v,
                        suffix: '×',
                      ),
                      slider(
                        label: 'Bubble bottom (% of circle)',
                        value: bubbleBottomPct,
                        min: -0.10,
                        max: 0.20,
                        divisions: 30,
                        onChanged: (v) => bubbleBottomPct = v,
                        suffix: '×',
                      ),
                      slider(
                        label: 'Creature Y offset (% of circle)',
                        value: creatureYOffsetPct,
                        min: -0.25,
                        max: 0.20,
                        divisions: 45,
                        onChanged: (v) => creatureYOffsetPct = v,
                        suffix: '×',
                      ),

                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Visual polish
                      slider(
                        label: 'Bubble elevation',
                        value: bubbleElevation,
                        min: 0,
                        max: 16,
                        divisions: 16,
                        onChanged: (v) => bubbleElevation = v,
                      ),
                      slider(
                        label: 'Circle lightness',
                        value: circleLightness,
                        min: 0.85,
                        max: 0.98,
                        divisions: 13,
                        onChanged: (v) => circleLightness = v,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _reset();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
