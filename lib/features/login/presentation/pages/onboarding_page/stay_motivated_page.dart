import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StayMotivatedPage extends StatelessWidget {
  const StayMotivatedPage({super.key});

  // --- TUNING KNOBS (only for title & subtitle) ---
  static const double kTitleTopPct    = 0.60; // geser naik/turun judul
  static const double kSubtitleTopPct = 0.64; // geser naik/turun subtitle

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;

        return Container(
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Top wave
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/features/onboarding/wave_top_white_blue.svg',
                  width: w,
                  fit: BoxFit.fitWidth,
                  semanticsLabel: 'Top wave',
                ),
              ),

              // Bottom wave
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'assets/features/onboarding/wave_bottom_yellow.svg',
                  width: w,
                  fit: BoxFit.fitWidth,
                  semanticsLabel: 'Bottom wave',
                ),
              ),

              // Creature
              Align(
                alignment: const Alignment(0.02, -0.28),
                child: SvgPicture.asset(
                  'assets/features/onboarding/creature_happy.svg',
                  width: w * 0.60,
                  fit: BoxFit.contain,
                  semanticsLabel: 'Happy creature',
                ),
              ),

              // Title (uses knob)
              Positioned(
                top: h * kTitleTopPct,
                left: 24,
                right: 24,
                child: const Text(
                  'Stay Motivated',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0A60DC),
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
              ),

              // Subtitle (uses knob)
              Positioned(
                top: h * kSubtitleTopPct,
                left: 24,
                right: 24,
                child: const Text(
                  'Earn more rewards and cute\nanimations along the journey!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
