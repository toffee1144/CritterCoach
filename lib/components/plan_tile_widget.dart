import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'plan_tile_model.dart';
export 'plan_tile_model.dart';

class PlanTileWidget extends StatefulWidget {
  const PlanTileWidget({super.key});

  @override
  State<PlanTileWidget> createState() => _PlanTileWidgetState();
}

class _PlanTileWidgetState extends State<PlanTileWidget> {
  late PlanTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlanTileModel());
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
        color: Colors.white,
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
            alignment: AlignmentDirectional(-0.8, 0.35),
            child: Icon(
              Icons.menu_book_sharp,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}
