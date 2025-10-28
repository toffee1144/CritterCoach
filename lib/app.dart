import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';

class CritterCareApp extends StatelessWidget {
  const CritterCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CritterCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC107)),
        scaffoldBackgroundColor: const Color(0xFFF9F6EF),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const HomePage(),
    );
  }
}
