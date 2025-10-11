import '/components/ai_chat_bubble_widget.dart';
import '/components/user_chat_bubble_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_chat_page_model.dart';
export 'ai_chat_page_model.dart';

class AiChatPageWidget extends StatefulWidget {
  const AiChatPageWidget({super.key});

  static String routeName = 'AiChatPage';
  static String routePath = '/aiChatPage';

  @override
  State<AiChatPageWidget> createState() => _AiChatPageWidgetState();
}

class _AiChatPageWidgetState extends State<AiChatPageWidget> {
  late AiChatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AiChatPageModel());
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
              SafeArea(
                child: Container(
                  width: 360.0,
                  height: 75.0,
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
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.97, 0.06),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.goNamed(PlannerPageWidget.routeName);
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: Color(0xFF2B3F6C),
                            size: 40.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          'AI Chatbot',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF2B3F6C),
                                    fontSize: 25.0,
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
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: SafeArea(
                    child: Container(
                      width: 360.0,
                      height: 720.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -0.83),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SvgPicture.asset(
                                'assets/images/creature_happy.svg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -0.96),
                            child: Text(
                              'Talk to Your Creature!',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF2B3F6C),
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 275.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-0.7, 0.0),
                                    child: wrapWithModel(
                                      model: _model.aiChatBubbleModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: AiChatBubbleWidget(),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.7, 0.0),
                                    child: wrapWithModel(
                                      model: _model.userChatBubbleModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: UserChatBubbleWidget(),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-0.7, 0.0),
                                    child: wrapWithModel(
                                      model: _model.aiChatBubbleModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: AiChatBubbleWidget(),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.7, 0.0),
                                    child: wrapWithModel(
                                      model: _model.userChatBubbleModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: UserChatBubbleWidget(),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-0.7, 0.0),
                                    child: wrapWithModel(
                                      model: _model.aiChatBubbleModel3,
                                      updateCallback: () => safeSetState(() {}),
                                      child: AiChatBubbleWidget(),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 15.0)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.91),
                            child: SafeArea(
                              child: Container(
                                width: 360.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x33000000),
                                      offset: Offset(2.0, 0.0),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 1.0),
                                  child: Container(
                                    width: 360.0,
                                    height: 1.0,
                                    child: Stack(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: SafeArea(
                                            child: Container(
                                              width: 334.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Color(0xFF979797),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Type a message here...',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  FlutterFlowIconButton(
                                                    borderRadius: 20.0,
                                                    buttonSize: 40.0,
                                                    fillColor:
                                                        Color(0xFF3380EF),
                                                    icon: Icon(
                                                      Icons.send,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      size: 24.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                ].divide(
                                                    SizedBox(width: 110.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
