import 'package:critter_care/features/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'meet_creature_page.dart';
import 'daily_quest_page.dart';
import 'stay_motivated_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.onFinish});
  final VoidCallback? onFinish;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _ctrl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _index = i),
              children: const [
                MeetCreaturePage(),
                DailyQuestsPage(),
                StayMotivatedPage(),
              ],
            ),
            Align(
              alignment: const Alignment(0, 0.64),
              child: SmoothPageIndicator(
                controller: _ctrl,
                count: 3,
                effect: const SlideEffect(
                  spacing: 8, radius: 8,
                  dotWidth: 12, dotHeight: 12,
                  dotColor: Color(0xFFD9D9D9),
                  activeDotColor: Color(0xFF0A60DC),
                ),
                onDotClicked: (i) => _ctrl.animateToPage(
                  i, duration: const Duration(milliseconds: 350), curve: Curves.easeOut),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.80),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _index == 2 ? const Color(0xFFFFDA27) : Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    ),
onPressed: () async {
if (_index != 2) {
_ctrl.nextPage(
duration: const Duration(milliseconds: 300),
curve: Curves.ease,
);
return;
}
await sl<CurrentUserStore>().clear(); // hapus auth_user
if (!context.mounted) return;
Navigator.of(context).pushReplacement(
MaterialPageRoute(builder: (_) => const AuthPage()),
);
},
                    child: Text(_index == 2 ? "Let's Start" : 'Next'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
