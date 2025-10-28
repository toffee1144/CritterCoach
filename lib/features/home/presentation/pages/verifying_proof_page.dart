// verifying_proof_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'proof_result_success_page.dart';
import 'proof_result_failed_page.dart';

/// Immutable result object expected from the backend.
class VerifyOutcome {
  final bool pass;
  final int xp;
  final int bonus;
  final int coins;

  const VerifyOutcome({
    required this.pass,
    this.xp = 0,
    this.bonus = 0,
    this.coins = 0,
  });

  VerifyOutcome copyWith({
    bool? pass,
    int? xp,
    int? bonus,
    int? coins,
  }) {
    return VerifyOutcome(
      pass: pass ?? this.pass,
      xp: xp ?? this.xp,
      bonus: bonus ?? this.bonus,
      coins: coins ?? this.coins,
    );
  }
}

class VerifyingProofPage extends StatefulWidget {
  const VerifyingProofPage({
    super.key,
    this.preview,
    required this.verify,                 // MUST: Future<VerifyOutcome> Function()
    this.minScreenTime = const Duration(seconds: 20),
    this.verifyTimeout = const Duration(seconds: 120),
    this.verifyRetries = 1,               // total attempts = 1 + verifyRetries
    this.retryBackoff = const Duration(milliseconds: 4000),
    this.fallbackWhenError = false,       // production: keep false (error != pass)
    this.headline = 'Verifying Your Proof',
    this.waitingText = 'Please wait a moment…',
  });

  final ImageProvider? preview;
  final Future<VerifyOutcome> Function() verify;

  final Duration minScreenTime;
  final Duration verifyTimeout;
  final int verifyRetries;
  final Duration retryBackoff;
  final bool fallbackWhenError;

  final String headline;
  final String waitingText;

  @override
  State<VerifyingProofPage> createState() => _VerifyingProofPageState();
}

class _VerifyingProofPageState extends State<VerifyingProofPage> {
  double _progress = 0.0;
  bool _verifyDone = false;
  Timer? _progressTimer;

  // ---------- logging helper ----------
  void _log(String msg) {
    final ts = DateTime.now().toIso8601String();
    // pake print biar nongol juga di Chrome DevTools (Flutter Web) & log Android
    print('[VerifyingProofPage][$ts] $msg');
  }

  @override
  void initState() {
    super.initState();
    _log('initState() preview=${widget.preview != null} '
         'minScreen=${widget.minScreenTime.inSeconds}s '
         'timeout=${widget.verifyTimeout.inSeconds}s '
         'retries=${widget.verifyRetries} '
         'backoff=${widget.retryBackoff.inMilliseconds}ms '
         'fallbackWhenError=${widget.fallbackWhenError}');
    _startProgressLoop();
    _runAndRedirect();
  }

  @override
  void dispose() {
    _log('dispose() cancel progress timer');
    _progressTimer?.cancel();
    super.dispose();
  }

  // Progress anim: hold ~90% while waiting, then finish to 100% when verify done.
  void _startProgressLoop() {
    const tick = Duration(milliseconds: 50);
    int ticks = 0;
    _progressTimer = Timer.periodic(tick, (t) {
      if (!mounted) return;
      ticks++;
      final cap = _verifyDone ? 1.0 : 0.9;
      final step = _verifyDone ? 0.06 : 0.02;
      final next = (_progress + step).clamp(0.0, cap);
      if (next == _progress && _verifyDone) {
        _log('progress loop stop at 100% after $ticks ticks');
        t.cancel();
      } else {
        _progress = next;
        if (ticks % 10 == 0) {
          _log('progress=${(_progress * 100).toStringAsFixed(0)}% (verifyDone=$_verifyDone)');
        }
        setState(() {});
      }
    });
    _log('progress loop started');
  }

  /// Run verify with per-attempt timeout & retries.
  /// Never throws; always returns a normalized VerifyOutcome.
  Future<VerifyOutcome> _safeVerify() async {
    final total = 1 + (widget.verifyRetries < 0 ? 0 : widget.verifyRetries);
    _log('_safeVerify() totalAttempts=$total');

    for (var attempt = 1; attempt <= total; attempt++) {
      final started = DateTime.now();
      _log('attempt #$attempt START (timeout=${widget.verifyTimeout.inSeconds}s)');
      try {
        final out = await widget.verify().timeout(widget.verifyTimeout);

        final latency = DateTime.now().difference(started).inMilliseconds;
        _log('attempt #$attempt SUCCESS in ${latency}ms '
             '=> pass=${out.pass}, xp=${out.xp}, bonus=${out.bonus}, coins=${out.coins}');

        // Normalize (safeguard)
        return VerifyOutcome(
          pass: out.pass == true,
          xp: out.xp is int ? out.xp : 0,
          bonus: out.bonus is int ? out.bonus : 0,
          coins: out.coins is int ? out.coins : 0,
        );
      } catch (e, st) {
        final latency = DateTime.now().difference(started).inMilliseconds;
        _log('attempt #$attempt FAIL in ${latency}ms -> $e');
        _log('stack: $st');

        if (attempt < total) {
          _log('backoff ${widget.retryBackoff.inMilliseconds}ms before retry…');
          await Future.delayed(widget.retryBackoff);
        } else {
          _log('no more attempts left, will return fallback=${widget.fallbackWhenError}');
        }
      }
    }

    // All attempts failed/timeout → explicit fallback
    return VerifyOutcome(pass: widget.fallbackWhenError);
  }

  Future<void> _runAndRedirect() async {
    final t0 = DateTime.now();
    _log('_runAndRedirect() BEGIN');

    // 1) Call guarded verify
    final out = await _safeVerify();
    _verifyDone = true; // let progress finish to 100%
    _log('_safeVerify() RESULT => pass=${out.pass}, xp=${out.xp}, bonus=${out.bonus}, coins=${out.coins}');

    // 2) Maintain min dwell time (UX)
    final elapsed = DateTime.now().difference(t0);
    final remain = widget.minScreenTime - elapsed;
    _log('dwell: elapsed=${elapsed.inMilliseconds}ms, '
         'minScreen=${widget.minScreenTime.inMilliseconds}ms, '
         'remain=${remain.inMilliseconds}ms');
    if (remain.inMilliseconds > 0) {
      await Future.delayed(remain);
    }
    if (!mounted) {
      _log('not mounted anymore, abort navigate');
      return;
    }

    // 3) Make sure progress is full and give a short settle
    setState(() => _progress = 1.0);
    _log('progress forced to 100%, settle 150ms');
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) {
      _log('not mounted after settle, abort navigate');
      return;
    }

    // 4) Decide & navigate
    if (out.pass) {
      _log('NAVIGATE -> ProofResultSuccessPage');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProofResultSuccessPage(
            xpPoints: out.xp,
            bonusPoints: out.bonus,
            coins: out.coins,
          ),
        ),
      );
    } else {
      _log('NAVIGATE -> ProofResultFailedPage');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ProofResultFailedPage(
            headline: 'Proof Rejected',
            sub: 'Try again please!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.16, 1.0],
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF69E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Stack(
              children: [
                // Content column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.headline,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF31496B),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preview card
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF7BA6F6), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        image: widget.preview != null
                            ? DecorationImage(image: widget.preview!, fit: BoxFit.cover)
                            : null,
                      ),
                      child: widget.preview == null
                          ? const Center(
                              child: Text(
                                'No preview',
                                style: TextStyle(color: Color(0xFF8A8A8A)),
                              ),
                            )
                          : null,
                    ),

                    const SizedBox(height: 18),

                    // Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 16,
                        backgroundColor: const Color(0xFFE9EDF5),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFF5C8DF6)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Checking...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF31496B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_progress * 100).clamp(0, 100).round()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF31496B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Creature + bubble (bottom-right)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.waitingText,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1F1F1F)),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 120,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0x33000000),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/global/icons/creature.svg', // ensure the asset exists
                            width: 120,
                            height: 120,
                            semanticsLabel: 'Creature',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
