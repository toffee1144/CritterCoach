import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../di/injector.dart';
import '../../domain/entities/dashboard.dart';
import '../state/home_notifier.dart';
import '../widgets/homepage/header_panel.dart';
import '../widgets/homepage/daily_quests_panel.dart';
import '../widgets/homepage/quests_split_panel.dart';
import '../../../../core/ui/app_colors.dart';
import '../../../../core/ui/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const int _userId = 1;
  static DateTime get _today => DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<HomeNotifier>()..load(userId: _userId, date: _today),
      child: Consumer<HomeNotifier>(
        builder: (context, vm, _) {
          final Dashboard? d = vm.dashboard;
          final String? error = vm.error;
          final bool loading = vm.loading;

          // ---- Build BODY only; AppScaffold provides the Scaffold + bottom nav
          final body = Container(
            // gradient background like your previous Scaffold
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.16, 1.0],
                colors: [Color(0xFFFFFFFF), Color(0xFFFFF69E)],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<HomeNotifier>().load(userId: _userId, date: _today),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
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
                              const SizedBox(height: 24),
                              const Center(child: CircularProgressIndicator()),
                              const SizedBox(height: 24),
                            ],

                            // Panels
                            DailyQuestsPanel(
                              dashboard: d,
                              onDailyQuests: () {},
                              onHabitReminder: () {},
                            ),
                            const SizedBox(height: 16),
                            QuestsSplitPanel(quests: d?.quests ?? const []),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );

          // Use the global scaffold with bottom nav
          return AppScaffold(
            currentIndex: 0,          // 0 = Home tab
            body: body,               // content above
            background: AppColors.softYellow, // optional scaffold bg
          );
        },
      ),
    );
  }
}
