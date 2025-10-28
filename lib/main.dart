import 'package:flutter/material.dart';

import 'di/injector.dart'; // ⬅️ penting: untuk configureDependencies
import 'features/login/presentation/pages/onboarding_page/onboarding_page.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // register GetIt (datasource, repo, usecase)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CritterCare',
      // Pakai Builder agar dapat context untuk Navigator di callback
      home: Builder(
        builder: (context) => OnboardingPage(
          onFinish: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomePage()), // tanpa const OK
            );
          },
        ),
      ),
    );
  }
}
