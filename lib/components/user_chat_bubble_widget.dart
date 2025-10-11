import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_chat_bubble_model.dart';
export 'user_chat_bubble_model.dart';

class UserChatBubbleWidget extends StatefulWidget {
  const UserChatBubbleWidget({super.key});

  @override
  State<UserChatBubbleWidget> createState() => _UserChatBubbleWidgetState();
}

class _UserChatBubbleWidgetState extends State<UserChatBubbleWidget> {
  late UserChatBubbleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserChatBubbleModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: Color(0xFFE2EAF9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Text(
          'Hello User! Nice to meet you!',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.roboto(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ),
    );
  }
}
