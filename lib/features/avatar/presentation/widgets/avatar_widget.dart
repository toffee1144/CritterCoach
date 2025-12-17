import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/models/avatar_state.dart';

class AvatarWidget extends StatelessWidget {
  final AvatarState state;
  const AvatarWidget({super.key, required this.state});

  void _log(String msg) {
    // ignore: avoid_print
    print('[AvatarWidget] $msg');
  }

  @override
  Widget build(BuildContext context) {
    _log('Rendering avatar...');
    _log(' body = ${state.body}');
    _log(' backAccessory = ${state.backAccessory}');
    _log(' outfit = ${state.outfit}');
    _log(' hair = ${state.hair}');
    _log(' headAccessory = ${state.headAccessory}');
    _log(' faceAccessory = ${state.faceAccessory}');
    _log(' accessory = ${state.accessory}');

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. BACK ACCESSORY
        if (state.backAccessory != null)
          SvgPicture.asset(
            state.backAccessory!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        // 2. BODY
        SvgPicture.asset(
          'assets/avatar/base/Creature.svg',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),

        // 3. OUTFIT
        if (state.outfit != null)
          SvgPicture.asset(
            state.outfit!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        // 4. ACCESSORY (Balloon, Watch) → taruh di atas outfit, di bawah hair/head
        if (state.accessory != null)
          SvgPicture.asset(
            state.accessory!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        // 5. HAIR
        if (state.hair != null)
          SvgPicture.asset(
            state.hair!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        // 6. HEAD ACCESSORY
        if (state.headAccessory != null)
          SvgPicture.asset(
            state.headAccessory!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        // 7. FACE ACCESSORY (glasses)
        if (state.faceAccessory != null)
          SvgPicture.asset(
            state.faceAccessory!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
      ],
    );
  }
}
