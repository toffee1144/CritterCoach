import 'package:critter_care/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// ===== Colors (close to Figma) =====
const _bgBeige = Color(0xFFF5E8CC);
const _inkDeepBlue = Color(0xFF31496B);
const _ink = Color(0xFF1F1F1F);
const _muted = Color(0xFF6B6B6B);
const _card = Colors.white;
const _coinYellow = Color(0xFFFFB300);
const _primaryBlue = Color(0xFF2C7BE5);

/// ===== Assets (adjust if needed) =====
const _svgMascot  = 'assets/global/icons/creature_success.svg';
const _svgXp      = 'assets/features/homepage/ic_xp.svg';
const _svgPoints  = 'assets/features/homepage/ic_points.svg';

EdgeInsets get _pagePad => const EdgeInsets.fromLTRB(16, 14, 16, 24);

class ProofResultSuccessPage extends StatelessWidget {
  final int xpPoints;
  final int bonusPoints;
  final int coins;
  final VoidCallback? onContinue;

  const ProofResultSuccessPage({
    super.key,
    required this.xpPoints,
    required this.bonusPoints,
    required this.coins,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bgBeige,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: _pagePad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              Text(
                'Success!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _inkDeepBlue,
                  letterSpacing: .2,
                ),
              ),
              const SizedBox(height: 14),

              // Mascot
              FractionallySizedBox(
                widthFactor: 0.70,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _SafeSvg(
                    asset: _svgMascot,
                    fit: BoxFit.contain,
                    fallback: const Center(
                      child: Icon(Icons.broken_image_rounded, size: 36),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===== Rewards card =====
              FractionallySizedBox(
                widthFactor: 0.86,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1 — XP (icon and text share one baseline via WidgetSpan)
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: _IconSquare(svgPath: _svgXp),
                            ),
                            const WidgetSpan(child: SizedBox(width: 12)),
                            TextSpan(
                              text: '+$xpPoints Points  ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: _primaryBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: '+$bonusPoints ',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: _ink,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'bonus',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: _muted,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),

                      const SizedBox(height: 12),

                      // Divider aligned with text (indented past the icon + gap)
                      const Divider(
                        height: 1,
                        thickness: .9,
                        color: Color(0xFFE7E7E7),
                        indent: 26 + 12, // icon width + spacing
                      ),

                      const SizedBox(height: 12),

                      // Row 2 — Coins (same baseline trick)
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: _IconSquare(svgPath: _svgPoints),
                            ),
                            const WidgetSpan(child: SizedBox(width: 12)),
                            TextSpan(
                              text: '+$coins Coins',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFFF9900),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Continue button
              FractionallySizedBox(
                widthFactor: 0.72,
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 8,
                      shadowColor: const Color(0x33000000),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: onContinue ??
                        () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                                settings: RouteSettings(
                                  name: '/home',
                                  arguments: HomeRefreshArgs(), // optional
                                ),
                              ),
                              (route) => false,
                            ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Yellow rounded square with a safe SVG inside — matches the Figma chip.
class _IconSquare extends StatelessWidget {
  const _IconSquare({required this.svgPath});
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2BF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _coinYellow, width: 1),
      ),
      alignment: Alignment.center,
      child: _SafeSvg(
        asset: svgPath,
        width: 16,
        height: 16,
        fallback: const Icon(Icons.broken_image_rounded, size: 16),
      ),
    );
  }
}

/// Safe SVG loader: if the asset can't be found or parsed, show a fallback.
class _SafeSvg extends StatelessWidget {
  const _SafeSvg({
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final bundle = DefaultAssetBundle.of(context);
    final future = bundle.loadString(asset);

    return FutureBuilder<String>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) {
          return fallback ??
              Icon(
                Icons.broken_image_rounded,
                size: (width ?? height ?? 20),
                color: const Color(0xFFB00020),
              );
        }
        if (!snap.hasData) {
          return SizedBox(width: width, height: height);
        }
        return SvgPicture.string(
          snap.data!,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
