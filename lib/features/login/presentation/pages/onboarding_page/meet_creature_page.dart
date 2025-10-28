import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetCreaturePage extends StatelessWidget {
  const MeetCreaturePage({super.key});

  // --- TUNING KNOBS (percent of screen height) ---R
  static const double kTitleTopPct   = 0.06; // higher/lower title
  static const double kEllipseTopPct = 0.22; // background circle
  static const double kCreatureTopPct= 0.24; // character position
  static const double kCaptionTopPct = 0.60; // tagline text

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;

        return Stack(
          children: [
            // Yellow background
            Positioned.fill(
              child: Container(color: const Color(0xFFFFDA27)),
            ),

            // Bottom cream wave
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: SvgPicture.asset(
                'assets/features/onboarding/vector_wave_yellow.svg',
                width: w, fit: BoxFit.fitWidth,
              ),
            ),

            // Title
            Positioned(
              top: h * kTitleTopPct, left: 0, right: 0,
              child: const Text(
                'Meet Your\nCreature!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 44,
                  height: 1.05,
                  color: Colors.black,
                ),
              ),
            ),

            // White ellipse
            Positioned(
              top: h * kEllipseTopPct, left: 0, right: 0,
              child: SvgPicture.asset(
                'assets/features/onboarding/ellipse_bg.svg',
                width: w * 0.74,
                height: w * 0.74,
                fit: BoxFit.contain,
              ),
            ),

            // Creature
            Positioned(
              top: h * kCreatureTopPct, left: 0, right: 0,
              child: SvgPicture.asset(
                'assets/global/icons/creature.svg',
                width: w * 0.56,
                fit: BoxFit.contain,
              ),
            ),

            // Caption (keep it clear of the creature)
            Positioned(
              top: h * kCaptionTopPct, left: 24, right: 24,
              child: const Text(
                "They'll help you overcome laziness.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
