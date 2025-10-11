import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'failed_page_model.dart';
export 'failed_page_model.dart';

class FailedPageWidget extends StatefulWidget {
  const FailedPageWidget({super.key});

  static String routeName = 'FailedPage';
  static String routePath = '/failedPage';

  @override
  State<FailedPageWidget> createState() => _FailedPageWidgetState();
}

class _FailedPageWidgetState extends State<FailedPageWidget> {
  late FailedPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FailedPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 360.0,
                height: 800.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFFF4D7),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.05, -0.74),
                      child: Text(
                        'Failed',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0xFF2B3F6C),
                              fontSize: 40.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.02, -0.46),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SvgPicture.asset(
                          'assets/images/sad_creature.svg',
                          width: 185.0,
                          height: 300.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.66),
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            UploadProofPageWidget.routeName,
                            queryParameters: {
                              'taskIndex': serializeParam(
                                0,
                                ParamType.int,
                              ),
                            }.withoutNulls,
                          );
                        },
                        text: 'Continue',
                        options: FFButtonOptions(
                          width: 271.0,
                          height: 52.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFFFEAD00),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20.0),
                          hoverColor: Colors.white,
                          hoverTextColor: Color(0xFFFEAD00),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.15),
                      child: Text(
                        'Proof Rejected',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0xFF2B3F6C),
                              fontSize: 40.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.29),
                      child: Text(
                        'Try again please!',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0xFF2B3F6C),
                              fontSize: 30.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
