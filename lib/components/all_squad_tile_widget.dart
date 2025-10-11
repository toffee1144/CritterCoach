import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_squad_tile_model.dart';
export 'all_squad_tile_model.dart';

class AllSquadTileWidget extends StatefulWidget {
  const AllSquadTileWidget({super.key});

  @override
  State<AllSquadTileWidget> createState() => _AllSquadTileWidgetState();
}

class _AllSquadTileWidgetState extends State<AllSquadTileWidget> {
  late AllSquadTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllSquadTileModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 329.0,
      height: 82.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: FlutterFlowTheme.of(context).primaryText,
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(-0.9, 0.08),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SvgPicture.asset(
                'assets/images/studybuddy.svg',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.18, 0.59),
            child: Text(
              'Members: 8/10',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: Color(0xFF979797),
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.24, -0.5),
            child: Text(
              'Study Buddies',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.9, -0.06),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SvgPicture.asset(
                'assets/images/join_squads.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
