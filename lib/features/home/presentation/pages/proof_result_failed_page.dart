import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ==== Styles ====
const _bgTop = Color(0xFFFFFFFF);
const _bgBottom = Color(0xFFFFF69E);
const _titleColor = Color(0xFF31496B);
const _subtitleColor = Color(0xFF6B6B6B);
const _retryOrange = Color(0xFFFF9F1C);

EdgeInsets get _pagePad => const EdgeInsets.fromLTRB(20, 16, 20, 24);

// ==== Final Tweaks (no knobs) ====
const double _kTitleScale = 1.22;      // “Failed”
const double _kHeadlineScale = 1.80;   // “Proof Rejected”
const double _kSubScale = 1.10;        // “Try again please!”
const double _kIconWidthFactor = 0.61; // 61% lebar layar
const double _kIconYOffset = 0.05;     // 5% tinggi layar (turun +)
const double _kTitleYOffset = 0.05;    // 5% tinggi layar (turun +)

class ProofResultFailedPage extends StatelessWidget {
  final String headline;
  final String sub;
  final VoidCallback? onRetry;

  const ProofResultFailedPage({
    super.key,
    this.headline = 'Proof Rejected',
    this.sub = 'Try again please!',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenH = MediaQuery.of(context).size.height;

    final double titleBase =
        theme.textTheme.headlineMedium?.fontSize ?? 28;
    final double headlineBase =
        theme.textTheme.headlineSmall?.fontSize ?? 24;
    final double subBase =
        theme.textTheme.titleMedium?.fontSize ?? 16;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.16, 1.0],
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: _pagePad,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ===== Top: Title + Mascot =====
                        Column(
                          children: [
                            // Title offset 5% screen height
                            Transform.translate(
                              offset: Offset(0, screenH * _kTitleYOffset),
                              child: Text(
                                'Failed',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: _titleColor,
                                  fontSize: titleBase * _kTitleScale,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Icon with width factor + vertical offset 5%
                            Transform.translate(
                              offset: Offset(0, screenH * _kIconYOffset),
                              child: FractionallySizedBox(
                                widthFactor: _kIconWidthFactor,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: SvgPicture.asset(
                                    'assets/global/icons/creature_sad.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ===== Middle: Headline & subcopy =====
                        Column(
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              headline,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: _titleColor,
                                fontSize: headlineBase * _kHeadlineScale,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              sub,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: _subtitleColor,
                                fontWeight: FontWeight.w500,
                                fontSize: subBase * _kSubScale,
                              ),
                            ),
                          ],
                        ),

                        // ===== Bottom: Button =====
                        Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _retryOrange,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 6,
                                shadowColor: const Color(0x33000000),
                              ),
                              onPressed:
                                  onRetry ?? () => Navigator.of(context).maybePop(),
                              child: const Text(
                                'Retry',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
