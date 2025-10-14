import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'group_voice_call_model.dart';
export 'group_voice_call_model.dart';

class GroupVoiceCallWidget extends StatefulWidget {
  const GroupVoiceCallWidget({super.key});

  @override
  State<GroupVoiceCallWidget> createState() => _GroupVoiceCallWidgetState();
}

class _GroupVoiceCallWidgetState extends State<GroupVoiceCallWidget> {
  late GroupVoiceCallModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupVoiceCallModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 302.0,
      height: 46.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        alignment: AlignmentDirectional(0.0, 0.0),
        children: [
          Align(
            alignment: AlignmentDirectional(-0.9, 0.0),
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional(0.0, -1.0),
                  image: Image.asset(
                    'assets/images/creature.png',
                  ).image,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF3380EF),
                  width: 2.0,
                ),
              ),
              alignment: AlignmentDirectional(-1.0, 0.0),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.55, 0.0),
            child: Text(
              'Rian',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.47, -0.07),
            child: FaIcon(
              FontAwesomeIcons.volumeUp,
              color: Color(0xFFFFDA27),
              size: 20.0,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.69, -0.08),
            child: Icon(
              Icons.mic_none,
              color: Color(0xFF0A60DC),
              size: 25.0,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.92, -0.01),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SvgPicture.asset(
                'assets/images/voice_icon.svg',
                width: 24.0,
                height: 24.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
