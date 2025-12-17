import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgDebugPage extends StatelessWidget {
  const SvgDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          width: 160,
          height: 160,
          color: Colors.white,
          child: SvgPicture.asset(
            'assets/features/squads/icons/BG_Squad_Icon.svg',
            width: 120,
            height: 120,
            // kasih warna terang supaya pasti kelihatan
            colorFilter: const ColorFilter.mode(
              Colors.red,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
