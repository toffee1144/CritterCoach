import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'current_plan_tile_model.dart';
export 'current_plan_tile_model.dart';

class CurrentPlanTileWidget extends StatefulWidget {
  const CurrentPlanTileWidget({super.key});

  @override
  State<CurrentPlanTileWidget> createState() => _CurrentPlanTileWidgetState();
}

class _CurrentPlanTileWidgetState extends State<CurrentPlanTileWidget> {
  late CurrentPlanTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CurrentPlanTileModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 331.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: Color(0xFFE2EAF9),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(-0.87, -0.67),
            child: Text(
              '08:00 AM',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.2, 0.06),
            child: Text(
              'Strength Training 30-min',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0.57),
            child: FaIcon(
              FontAwesomeIcons.dumbbell,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}
