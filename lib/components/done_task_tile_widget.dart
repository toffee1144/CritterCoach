import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'done_task_tile_model.dart';
export 'done_task_tile_model.dart';

class DoneTaskTileWidget extends StatefulWidget {
  const DoneTaskTileWidget({
    super.key,
    required this.title,
    bool? checked,
  }) : this.checked = checked ?? true;

  final String? title;
  final bool checked;

  @override
  State<DoneTaskTileWidget> createState() => _DoneTaskTileWidgetState();
}

class _DoneTaskTileWidgetState extends State<DoneTaskTileWidget> {
  late DoneTaskTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DoneTaskTileModel());
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
          color: Color(0xFFFDF2D6),
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
                  unselectedWidgetColor: Color(0xFFFEAD00),
                ),
                child: Checkbox(
                  value: _model.checkboxValue ??= widget.checked,
                  onChanged: (newValue) async {
                    safeSetState(() => _model.checkboxValue = newValue!);
                    if (newValue!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'toggle diklik',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                      );
                    }
                  },
                  side: (Color(0xFFFEAD00) != null)
                      ? BorderSide(
                          width: 2,
                          color: Color(0xFFFEAD00),
                        )
                      : null,
                  activeColor: Color(0xFFFEAD00),
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
