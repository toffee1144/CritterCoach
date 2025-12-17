import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'di/injector.dart' as di;

import 'features/auth/auth_page.dart'; // AuthPage + CurrentUserStore
import 'features/login/presentation/pages/onboarding_page/onboarding_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/planner/presentation/pages/planner_page_widget.dart';
import 'features/chatbot/presentation/pages/chatbot_page.dart';
import 'features/rewards/presentaiton/pages/rewards_page.dart';
import 'features/squads/presentation/pages/squads_page.dart';
import 'features/profile/profile_page.dart';

import 'features/home/presentation/state/home_notifier.dart';
import 'features/planner/presentation/state/planner_notifier.dart';

class AppRoutes {
static const root = '/';
static const home = '/home';
static const planner = '/planner';
static const rewards = '/rewards';
static const squads = '/squads';
static const profile = '/profile';
static const chatbot = '/chatbot';
}

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);

await di.configureDependencies();

await di.sl<CurrentUserStore>().loadFromPrefs();

FlutterError.onError = FlutterError.presentError;
PlatformDispatcher.instance.onError = (_, __) => true;

runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
final navigatorKey = di.sl<GlobalKey<NavigatorState>>();
final userStore = di.sl<CurrentUserStore>();

return MultiProvider(
  providers: [
    ChangeNotifierProvider<CurrentUserStore>.value(value: userStore),
    ChangeNotifierProvider<HomeNotifier>(
      create: (_) => di.sl<HomeNotifier>(),
    ),
    ChangeNotifierProvider<PlannerNotifier>(
      create: (_) => di.sl<PlannerNotifier>(),
    ),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CritterCare',
    navigatorKey: navigatorKey,
    initialRoute: AppRoutes.root,
    routes: {
      AppRoutes.root: (_) => const RootGate(),
      AppRoutes.home: (_) => const HomePage(),
      AppRoutes.planner: (_) => const PlannerPageWidget(),
      AppRoutes.chatbot: (_) => const ChatPage(),
      AppRoutes.rewards: (_) => const RewardsPage(),
      AppRoutes.squads: (_) => const SquadsPage(),
      AppRoutes.profile: (_) => const ProfilePage(),
    },
    onUnknownRoute: (_) =>
        MaterialPageRoute(builder: (_) => const RootGate()),
  ),
);
}
}
class RootGate extends StatelessWidget {
const RootGate({super.key});

@override
Widget build(BuildContext context) {
final store = context.watch<CurrentUserStore>();

if (store.loading) {
  return const Scaffold(
    backgroundColor: Colors.white,
    body: Center(child: CircularProgressIndicator()),
  );
}

if (store.user != null) {
  return const HomePage();
}

return OnboardingPage(
  onFinish: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AuthPage(
          onAuthed: () {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.home);
          },
        ),
      ),
    );
  },
);
}
}
