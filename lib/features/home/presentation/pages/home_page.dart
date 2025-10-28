import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/dashboard.dart';
import '../state/home_notifier.dart';
import '../widgets/homepage/header_panel.dart';
import '../widgets/homepage/daily_quests_panel.dart';
import '../../../../core/ui/app_colors.dart';
import '../widgets/homepage/quest_card.dart'; // still used by split panel
import '../widgets/homepage/quests_split_panel.dart'; // ⬅️ add this

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const int _userId = 1; // TODO: replace with real user id
  static DateTime get _today => DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<HomeNotifier>()..load(userId: _userId, date: _today),
      child: Consumer<HomeNotifier>(
        builder: (context, vm, _) {
          final bool loading = vm.loading;
          final String? error = vm.error;
          final Dashboard? d = vm.dashboard;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.16, 1.0],
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFF69E)],
                ),
              ),
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<HomeNotifier>().load(userId: _userId, date: _today),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeaderPanel(userId: _userId, date: _today),
                        const SizedBox(height: 16),

                        if (error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(.25)),
                            ),
                            child: Text('Error: $error',
                                style: const TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(height: 12),
                        ],

                        if (loading && d == null) ...[
                          const Center(child: CircularProgressIndicator()),
                        ] else if (d != null) ...[
                          // Section pill headers (kept for parity with your mock)
                          DailyQuestsPanel(
                            dashboard: d,
                            onDailyQuests: () {},
                            onHabitReminder: () {},
                          ),
                          const SizedBox(height: 16),

                          // ⬇️ Replace the GridView with split columns:
                          QuestsSplitPanel(quests: d.quests),

                        ] else ...[
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              'No data available.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ===== Bottom Nav =====
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: AppColors.softYellow,
                  indicatorColor: Colors.white,
                  labelTextStyle: WidgetStateProperty.all(
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              child: NavigationBar(
                height: 72,
                destinations: [
                  NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
                  NavigationDestination(icon: Icon(Icons.event_note_rounded), label: 'Planner'),
                  NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Rewards'),
                  NavigationDestination(icon: Icon(Icons.groups_rounded), label: 'Study Squads'),
                  NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
                ],
                selectedIndex: 0,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Add this tiny class anywhere convenient (e.g., in a shared file)
class HomeRefreshArgs {
  final String reason;
  final DateTime ts;

  HomeRefreshArgs({this.reason = 'proof_success', DateTime? ts})
      : ts = ts ?? DateTime.now();
}
