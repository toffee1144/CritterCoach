import '/components/current_plan_tile_widget.dart';
import '/components/plan_tile_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'planner_page_model.dart';
export 'planner_page_model.dart';

class PlannerPageWidget extends StatefulWidget {
  const PlannerPageWidget({super.key});

  static String routeName = 'PlannerPage';
  static String routePath = '/plannerPage';

  @override
  State<PlannerPageWidget> createState() => _PlannerPageWidgetState();
}

class _PlannerPageWidgetState extends State<PlannerPageWidget>
    with TickerProviderStateMixin {
  late PlannerPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlannerPageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: 360.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.85, 0.24),
                              child: Text(
                                'Planner',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 30.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.89, 0.2),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(AiChatPageWidget.routeName);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: SvgPicture.asset(
                                    'assets/images/ai_chat.svg',
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 360.0,
                height: 725.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0.0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: false,
                          labelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                          unselectedLabelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).primaryText,
                          backgroundColor: Color(0xFFFFDA27),
                          borderWidth: 0.0,
                          borderRadius: 16.0,
                          elevation: 0.0,
                          buttonMargin: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          tabs: [
                            Tab(
                              text: 'Yesterday',
                            ),
                            Tab(
                              text: 'Mon 24',
                            ),
                            Tab(
                              text: 'Tomorrow',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Container(
                                      width: 360.0,
                                      height: 700.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFED7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 31.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, -1.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 0.0),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .currentPlanTileModel1,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child:
                                                      CurrentPlanTileWidget(),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final listPlanner =
                                                      List.generate(
                                                              random_data
                                                                  .randomInteger(
                                                                      5, 5),
                                                              (index) =>
                                                                  random_data
                                                                      .randomString(
                                                                    0,
                                                                    0,
                                                                    true,
                                                                    false,
                                                                    false,
                                                                  ))
                                                          .toList()
                                                          .take(10)
                                                          .toList();

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listPlanner.length,
                                                    itemBuilder: (context,
                                                        listPlannerIndex) {
                                                      final listPlannerItem =
                                                          listPlanner[
                                                              listPlannerIndex];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    13.0,
                                                                    10.0,
                                                                    13.0,
                                                                    0.0),
                                                        child: PlanTileWidget(
                                                          key: Key(
                                                              'Key5i7_${listPlannerIndex}_of_${listPlanner.length}'),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
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
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Container(
                                      width: 360.0,
                                      height: 700.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFED7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 31.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 360.0,
                                                  height: 700.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFED7),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 41.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                            child:
                                                                wrapWithModel(
                                                              model: _model
                                                                  .currentPlanTileModel2,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  CurrentPlanTileWidget(),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Builder(
                                                            builder: (context) {
                                                              final listPlanner =
                                                                  List.generate(
                                                                          random_data.randomInteger(
                                                                              5,
                                                                              5),
                                                                          (index) =>
                                                                              random_data
                                                                                  .randomString(
                                                                                0,
                                                                                0,
                                                                                true,
                                                                                false,
                                                                                false,
                                                                              ))
                                                                      .toList()
                                                                      .take(10)
                                                                      .toList();

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    listPlanner
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        listPlannerIndex) {
                                                                  final listPlannerItem =
                                                                      listPlanner[
                                                                          listPlannerIndex];
                                                                  return Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            13.0,
                                                                            10.0,
                                                                            13.0,
                                                                            0.0),
                                                                    child:
                                                                        PlanTileWidget(
                                                                      key: Key(
                                                                          'Keynuk_${listPlannerIndex}_of_${listPlanner.length}'),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
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
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Container(
                                      width: 360.0,
                                      height: 700.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFED7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 31.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 360.0,
                                                  height: 700.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFED7),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 41.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                            child:
                                                                wrapWithModel(
                                                              model: _model
                                                                  .currentPlanTileModel3,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  CurrentPlanTileWidget(),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Builder(
                                                            builder: (context) {
                                                              final listPlanner =
                                                                  List.generate(
                                                                          random_data.randomInteger(
                                                                              5,
                                                                              5),
                                                                          (index) =>
                                                                              random_data
                                                                                  .randomString(
                                                                                0,
                                                                                0,
                                                                                true,
                                                                                false,
                                                                                false,
                                                                              ))
                                                                      .toList()
                                                                      .take(10)
                                                                      .toList();

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    listPlanner
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        listPlannerIndex) {
                                                                  final listPlannerItem =
                                                                      listPlanner[
                                                                          listPlannerIndex];
                                                                  return Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            13.0,
                                                                            10.0,
                                                                            13.0,
                                                                            0.0),
                                                                    child:
                                                                        PlanTileWidget(
                                                                      key: Key(
                                                                          'Key9ip_${listPlannerIndex}_of_${listPlanner.length}'),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
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
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
