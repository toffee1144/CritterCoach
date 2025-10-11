import '/components/done_habit_tile_widget.dart';
import '/components/done_task_tile_widget.dart';
import '/components/habit_tile_widget.dart';
import '/components/task_tile_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 360.0,
                  height: 800.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Container(
                                width: 360.0,
                                height: 800.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: SvgPicture.asset(
                                    'assets/images/Homebg.svg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 360.0,
                        height: 800.0,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.8, -0.95),
                              child: Text(
                                'NickName',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 25.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.8, -0.85),
                              child: Container(
                                width: 104.0,
                                height: 23.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/Rectangle_11.svg',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.5, 0.03),
                                      child: Text(
                                        '7-Days Streaks',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.93, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/Group_14.svg',
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.contain,
                                          alignment: Alignment(-0.9, -0.9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.84, -0.96),
                              child: Container(
                                width: 105.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.48, -0.67),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/Rectangle_10.svg',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.57, -0.1),
                                      child: Text(
                                        '12000',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.8, 0.06),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/XP.svg',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.contain,
                                          alignment: Alignment(0.0, 0.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.78, -0.85),
                              child: Container(
                                width: 85.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE2EAF9),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.84, 0.01),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/Group_256.svg',
                                          width: 16.0,
                                          height: 16.0,
                                          fit: BoxFit.contain,
                                          alignment: Alignment(0.0, 0.0),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.08, 0.01),
                                      child: Text(
                                        '2500',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.81, -0.78),
                                      child: Text(
                                        'Coins',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 8.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
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
                              alignment: AlignmentDirectional(0.0, -0.65),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SvgPicture.asset(
                                  'assets/images/Ellipse_20.svg',
                                  width: 253.0,
                                  height: 253.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -0.68),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/creature.png',
                                  width: 150.0,
                                  height: 180.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -0.3),
                              child: Text(
                                'Creature',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -0.21),
                              child: Container(
                                width: 251.0,
                                height: 43.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -0.05),
                              child: Container(
                                width: 337.0,
                                height: 53.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFDA27),
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
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.7),
                                      child: Container(
                                        width: 300.0,
                                        height: 16.0,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: LinearPercentIndicator(
                                                percent: 0.6,
                                                width: 300.0,
                                                lineHeight: 12.0,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                progressColor:
                                                    Color(0xFFFEAD00),
                                                backgroundColor:
                                                    Color(0xFFFFF69E),
                                                barRadius:
                                                    Radius.circular(10.0),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.83, -0.41),
                                      child: Text(
                                        '4 of 6 Completed',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.82, -0.41),
                                      child: Text(
                                        'Today Daily Quests',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
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
                              alignment: AlignmentDirectional(0.8, 0.11),
                              child: Container(
                                width: 143.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3380EF),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0xFF3380EF),
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Habit Reminder',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.8, 0.11),
                              child: Container(
                                width: 143.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEAD00),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0xFFFEAD00),
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Daily Quests',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.75),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 175.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final listTask = _model.task.toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listTask.length,
                                      itemBuilder: (context, listTaskIndex) {
                                        final listTaskItem =
                                            listTask[listTaskIndex];
                                        return wrapWithModel(
                                          model: _model.taskTileModels.getModel(
                                            listTaskItem.toString(),
                                            listTaskIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: TaskTileWidget(
                                            key: Key(
                                              'Keyzur_${listTaskItem.toString()}',
                                            ),
                                            title: 'Exercising 30-min',
                                            checked: false,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.75),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              175.0, 0.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final listHabit = _model.task.toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listHabit.length,
                                      itemBuilder: (context, listHabitIndex) {
                                        final listHabitItem =
                                            listHabit[listHabitIndex];
                                        return wrapWithModel(
                                          model:
                                              _model.habitTileModels.getModel(
                                            _model.habit
                                                .containsMap(
                                                    _model.habit.firstOrNull)
                                                .toString(),
                                            listHabitIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: HabitTileWidget(
                                            key: Key(
                                              'Keyusx_${_model.habit.containsMap(_model.habit.firstOrNull).toString()}',
                                            ),
                                            title: 'Eat healthy Food',
                                            checked: false,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.28),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 175.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                wrapWithModel(
                                  model: _model.doneTaskTileModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: DoneTaskTileWidget(
                                    title: 'Run a lap',
                                    checked: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.28),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              175.0, 0.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                wrapWithModel(
                                  model: _model.doneHabitTileModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: DoneHabitTileWidget(
                                    title: 'Drink Water',
                                    checked: true,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
