import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'habit_tile_model.dart';
export 'habit_tile_model.dart';

class HabitTileWidget extends StatefulWidget {
  const HabitTileWidget({
    super.key,
    required this.title,
    bool? checked,
  }) : this.checked = checked ?? true;

  final String? title;
  final bool checked;

  @override
  State<HabitTileWidget> createState() => _HabitTileWidgetState();
}

class _HabitTileWidgetState extends State<HabitTileWidget> {
  late HabitTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HabitTileModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 5.0, 2.0),
      child: Container(
        width: 175.0,
        height: 43.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 3.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 3.0, 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.directions_run,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    AutoSizeText(
                      valueOrDefault<String>(
                        widget.title,
                        'Drink water',
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      minFontSize: 8.0,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(width: 6.0)),
                ),
              ),
              Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: CircleBorder(),
                  ),
                  unselectedWidgetColor: Color(0xFF3380EF),
                ),
                child: Checkbox(
                  value: _model.checkboxValue ??= widget.checked,
                  onChanged: (newValue) async {
                    safeSetState(() => _model.checkboxValue = newValue!);
                    if (newValue!) {
                      context.pushNamed(
                        UploadProofPageWidget.routeName,
                        queryParameters: {
                          'taskIndex': serializeParam(
                            0,
                            ParamType.int,
                          ),
                        }.withoutNulls,
                      );
                    }
                  },
                  side: (Color(0xFF3380EF) != null)
                      ? BorderSide(
                          width: 2,
                          color: Color(0xFF3380EF),
                        )
                      : null,
                  activeColor: Color(0xFF3380EF),
                  checkColor: FlutterFlowTheme.of(context).info,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
