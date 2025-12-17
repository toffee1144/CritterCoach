import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? background;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.body,
    this.appBar,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? Theme.of(context).colorScheme.background,
      appBar: appBar,
      body: SafeArea(top: true, bottom: false, child: body),
      bottomNavigationBar: AppBottomNav(currentIndex: currentIndex),
    );
  }
}
