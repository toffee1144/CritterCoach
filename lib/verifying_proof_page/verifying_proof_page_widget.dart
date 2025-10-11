import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'verifying_proof_page_model.dart';
export 'verifying_proof_page_model.dart';

class VerifyingProofPageWidget extends StatefulWidget {
  const VerifyingProofPageWidget({
    super.key,
    required this.taskIndex,
    this.taskTitle,
  });

  final int? taskIndex;
  final String? taskTitle;

  static String routeName = 'VerifyingProofPage';
  static String routePath = '/verifyingProofPage';

  @override
  State<VerifyingProofPageWidget> createState() =>
      _VerifyingProofPageWidgetState();
}

class _VerifyingProofPageWidgetState extends State<VerifyingProofPageWidget> {
  late VerifyingProofPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerifyingProofPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.goNamed(SuccessPageWidget.routeName);
    });
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
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 360.0,
                    height: 800.0,
                    decoration: BoxDecoration(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SvgPicture.asset(
                        'assets/images/Homebg.svg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: 360.0,
                    height: 800.0,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -0.8),
                          child: Text(
                            'Verifying Your Proof',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF2B3F6C),
                                  fontSize: 32.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.96, -0.93),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Color(0xFF2B3F6C),
                              size: 35.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.73, 0.71),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/creature.png',
                              width: 150.0,
                              height: 175.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, -0.4),
                          child: Container(
                            width: 292.0,
                            height: 275.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Color(0xFF3380EF),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.73, 0.71),
                          child: Container(
                            width: 251.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    4.0,
                                  ),
                                )
                              ],
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
                                'Please wait a moment....',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.14),
                          child: Container(
                            width: 300.0,
                            height: 20.0,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.21),
                              child: LinearPercentIndicator(
                                percent: 0.5,
                                width: 300.0,
                                lineHeight: 24.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: Color(0xFF3380EF),
                                backgroundColor: Color(0xFFE2EAF9),
                                barRadius: Radius.circular(20.0),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.75, 0.22),
                    child: Text(
                      'Checking...',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF2B3F6C),
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
