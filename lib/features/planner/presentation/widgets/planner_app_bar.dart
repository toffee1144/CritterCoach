// lib/features/planner/presentation/widgets/planner_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../main.dart';

class PlannerAppBar extends StatelessWidget {
  const PlannerAppBar({
    super.key,
    this.onTapChat, // optional action when the icon is tapped
  });

  final VoidCallback? onTapChat;

  @override
  Widget build(BuildContext context) {
    final titleStyle = (Theme.of(context).textTheme.bodyMedium ??
            const TextStyle(fontSize: 16))
        .copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        );

    return SizedBox(
      height: 75,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Planner', style: titleStyle),
            const Spacer(),
            InkWell(
              onTap: onTapChat ?? () => Navigator.of(context).pushNamed(AppRoutes.chatbot),
              child: SizedBox(
                width: 40,
                height: 40,
                child: SvgPicture.asset(
                  'assets/features/planner/chat_icon.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
