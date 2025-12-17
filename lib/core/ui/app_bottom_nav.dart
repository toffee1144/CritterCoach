import 'package:critter_care/features/profile/profile_page.dart';
import 'package:critter_care/features/rewards/presentaiton/pages/rewards_page.dart';
import 'package:critter_care/features/squads/presentation/pages/squads_page.dart';
import 'package:critter_care/svg_debug_page.dart';
import 'package:flutter/material.dart';
import '../../di/injector.dart';
import '../router/app_routes.dart';
import 'app_colors.dart';

// Import pages for no-animation pushReplacement (Option A)
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/planner/presentation/pages/planner_page_widget.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex; // 0=Home,1=Planner,2=Rewards,3=Squads,4=Profile
  const AppBottomNav({super.key, required this.currentIndex});

  // --- No-animation route helper ---
  PageRoute<T> _noAnim<T>(Widget page) => PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  void _go(int i) {
    if (i == currentIndex) return;
    final nav = sl<GlobalKey<NavigatorState>>().currentState!;
    switch (i) {
      case 0:
        nav.pushReplacement(_noAnim(const HomePage()));
        break;
      case 1:
        nav.pushReplacement(_noAnim(const PlannerPageWidget()));
        break;
      case 2:
        nav.pushReplacement(_noAnim(const RewardsPage()));
        // nav.pushReplacement(_noAnim(const SvgDebugPage()));

        break;
      case 3:
        // TODO: Replace with your Study Squads page
        nav.pushReplacement(_noAnim(const SquadsPage()));
        break;
      case 4:
        // TODO: Replace with your Profile page
        nav.pushReplacement(_noAnim(const ProfilePage()));
        break;
    }

    // --- If you prefer named routes (will animate by default), use this instead:
    // switch (i) {
    //   case 0: nav.pushReplacementNamed(AppRoutes.home);    break;
    //   case 1: nav.pushReplacementNamed(AppRoutes.planner); break;
    //   case 2: nav.pushReplacementNamed(AppRoutes.rewards); break;
    //   case 3: nav.pushReplacementNamed(AppRoutes.squads);  break;
    //   case 4: nav.pushReplacementNamed(AppRoutes.profile); break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
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
        selectedIndex: currentIndex,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded),         label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_note_rounded),   label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Rewards'),
          NavigationDestination(icon: Icon(Icons.groups_rounded),       label: 'Squads'),
          NavigationDestination(icon: Icon(Icons.person_rounded),       label: 'Profile'),
        ],
      ),
    );
  }
}
