import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/planner_notifier.dart';
import '../state/planner_state.dart';
import '../widgets/planner_tab_bar.dart';
import '../widgets/planner_tab_view.dart';
import '../widgets/planner_app_bar.dart';
import '../../../../core/ui/app_scaffold.dart';

class PlannerPageWidget extends StatefulWidget {
  const PlannerPageWidget({super.key});

  static String routeName = 'PlannerPage';
  static String routePath = '/plannerPage';

  @override
  State<PlannerPageWidget> createState() => _PlannerPageWidgetState();
}

class _PlannerPageWidgetState extends State<PlannerPageWidget>
    with TickerProviderStateMixin {
  late TabController _tabC;

  static String _weekday(int w) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];

  List<String> get _labels {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(PlannerNotifier.totalTabs, (i) {
      final d = today.add(
        Duration(days: i - PlannerNotifier.range),
      );
      return '${_weekday(d.weekday)} ${d.day}';
    });
  }

  Future<void> _showAddSheet() async {
    final titleC = TextEditingController();
    TimeOfDay selTime = TimeOfDay.now();
    int difficulty = 1;

    final result = await showModalBottomSheet<({String title, TimeOfDay time, int difficulty})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final viewInsets = MediaQuery.viewInsetsOf(ctx);
        return StatefulBuilder(
          builder: (ctx, setS) {
            return Padding(
              padding: EdgeInsets.only(bottom: viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Add plan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFED7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              TextField(
                                controller: titleC,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Name (e.g., Strength Training)',
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Time',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  FilledButton.tonal(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFDA27).withOpacity(0.35),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final picked = await showTimePicker(
                                        context: ctx,
                                        initialTime: selTime,
                                        builder: (context, child) {
                                          final base = Theme.of(context);
                                          return Theme(
                                            data: base.copyWith(
                                              colorScheme: base.colorScheme.copyWith(
                                                primary: const Color(0xFFFFDA27),
                                                onPrimary: Colors.black,
                                                surface: Colors.white,
                                                onSurface: Colors.black87,
                                              ),
                                              timePickerTheme: const TimePickerThemeData(
                                                backgroundColor: Colors.white,
                                                hourMinuteColor: Color(0xFFFFFED7),
                                                hourMinuteTextColor: Colors.black87,
                                                dialBackgroundColor: Color(0xFFFFFED7),
                                                dialHandColor: Color(0xFFFFDA27),
                                                dialTextColor: Colors.black87,
                                                entryModeIconColor: Colors.black87,
                                                dayPeriodColor: Color(0xFFFFFED7),
                                                dayPeriodTextColor: Colors.black87,
                                                dayPeriodBorderSide: BorderSide(color: Color(0xFFFFDA27)),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) setS(() => selTime = picked);
                                    },
                                    child: Text(selTime.format(ctx)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Difficulty',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(5, (i) {
                                  final v = i + 1;
                                  final selected = difficulty == v;
                                  return ChoiceChip(
                                    selected: selected,
                                    onSelected: (_) => setS(() => difficulty = v),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bolt, size: 16),
                                        const SizedBox(width: 6),
                                        Text(v.toString()),
                                      ],
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: selected
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.75),
                                    ),
                                    selectedColor: const Color(0xFFFFDA27),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: BorderSide(
                                        color: Colors.black.withOpacity(0.08),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.black.withOpacity(0.18)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFDA27),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  final t = titleC.text.trim().isEmpty
                                      ? 'New Plan'
                                      : titleC.text.trim();
                                  Navigator.pop(ctx, (title: t, time: selTime, difficulty: difficulty));
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      await context.read<PlannerNotifier>().addFromPicker(
            result.time,
            result.title,
            result.difficulty,
          );
    }
  }

  @override
  void initState() {
    super.initState();

    _tabC = TabController(
      length: PlannerNotifier.totalTabs,
      vsync: this,
      initialIndex: PlannerNotifier.range,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PlannerNotifier>().loadForTab(_tabC.index);
    });

    _tabC.addListener(() {
      if (_tabC.indexIsChanging) return;
      context.read<PlannerNotifier>().loadForTab(_tabC.index);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabC.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog() async {
    final titleC = TextEditingController();
    TimeOfDay selTime = TimeOfDay.now();
    int difficulty = 1;

    final result =
        await showDialog<({String title, TimeOfDay time, int difficulty})>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) => AlertDialog(
            title: const Text('Add plan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleC,
                  decoration: const InputDecoration(
                    labelText: 'Name (e.g., Strength Training)',
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Time:'),
                    const SizedBox(width: 12),
                    FilledButton.tonal(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: selTime,
                        );
                        if (picked != null) {
                          setS(() => selTime = picked);
                        }
                      },
                      child: Text(selTime.format(ctx)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Difficulty:'),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: difficulty,
                      items: List.generate(5, (i) {
                        final v = i + 1;
                        return DropdownMenuItem(
                          value: v,
                          child: Text(v.toString()),
                        );
                      }),
                      onChanged: (v) {
                        if (v == null) return;
                        setS(() => difficulty = v);
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final t = titleC.text.trim().isEmpty
                      ? 'New Plan'
                      : titleC.text.trim();
                  Navigator.pop(
                    ctx,
                    (title: t, time: selTime, difficulty: difficulty),
                  );
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && mounted) {
      await context.read<PlannerNotifier>().addFromPicker(
            result.time,
            result.title,
            result.difficulty,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlannerNotifier>().state;

    final body = Column(
      children: [
        const SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: PlannerAppBar(),
          ),
        ),
        const SizedBox(height: 8),
        PlannerTabBar(
          controller: _tabC,
          labels: _labels,
          onTap: (i) =>
              context.read<PlannerNotifier>().loadForTab(i),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFED7),
            ),
            child: Builder(
              builder: (_) {
                switch (state) {
                  case PlannerInitial():
                    return const SizedBox.shrink();
                  case PlannerLoading():
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PlannerError(:final message):
                    return Center(
                      child: Text('Error: $message'),
                    );
                  case PlannerLoaded(:final plans):
                    return PlannerTabView(plans: plans);
                }
              },
            ),
          ),
        ),
      ],
    );

    final bottomOffset = MediaQuery.sizeOf(context).height * 0.10;

    final fab = FloatingActionButton.extended(
      onPressed: _showAddSheet,
      backgroundColor: const Color(0xFFFFDA27),
      foregroundColor: Colors.black,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      icon: const Icon(Icons.add),
      label: const Text(
        'Planner',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    return AppScaffold(
      currentIndex: 1,
      body: Stack(
        children: [
          body,
          Positioned(
            right: 16,
            bottom: bottomOffset,
            child: fab,
          ),
        ],
      ),
      background: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
