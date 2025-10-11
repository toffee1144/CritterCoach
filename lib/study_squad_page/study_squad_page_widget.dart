import '/components/all_squad_tile_widget.dart';
import '/components/my_squad_tile_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'study_squad_page_model.dart';
export 'study_squad_page_model.dart';

class StudySquadPageWidget extends StatefulWidget {
  const StudySquadPageWidget({super.key});

  static String routeName = 'StudySquadPage';
  static String routePath = '/studySquadPage';

  @override
  State<StudySquadPageWidget> createState() => _StudySquadPageWidgetState();
}

class _StudySquadPageWidgetState extends State<StudySquadPageWidget> {
  late StudySquadPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StudySquadPageModel());
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
              Expanded(
                child: Container(
                  width: 360.0,
                  height: 800.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-0.81, -0.88),
                            child: Text(
                              'Study Squads',
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
                            alignment: AlignmentDirectional(0.88, -0.9),
                            child: Container(
                              width: 121.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFDA27),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  width: 2.0,
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                      CreateSquadPageWidget.routeName);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 30.0,
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Text(
                                        'Create\nSquads',
                                        textAlign: TextAlign.center,
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
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ]
                                      .divide(SizedBox(width: 6.0))
                                      .addToStart(SizedBox(width: 4.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.84, -0.74),
                        child: Container(
                          width: 163.0,
                          height: 47.0,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/bg_mysquads.png',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'My Squads',
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
                                        fontSize: 20.0,
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
                        alignment: AlignmentDirectional(-0.84, -0.06),
                        child: Container(
                          width: 163.0,
                          height: 47.0,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/bg_allsquads.png',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'All Squads',
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
                                        fontSize: 20.0,
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
                        alignment: AlignmentDirectional(0.0, -0.28),
                        child: wrapWithModel(
                          model: _model.mySquadTileModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: MySquadTileWidget(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -0.55),
                        child: wrapWithModel(
                          model: _model.mySquadTileModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: MySquadTileWidget(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.9),
                                child: Builder(
                                  builder: (context) {
                                    final listAllSquads = List.generate(
                                        random_data.randomInteger(5, 5),
                                        (index) => random_data.randomString(
                                              0,
                                              0,
                                              true,
                                              false,
                                              false,
                                            )).toList();

                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listAllSquads.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 14.0),
                                      itemBuilder:
                                          (context, listAllSquadsIndex) {
                                        final listAllSquadsItem =
                                            listAllSquads[listAllSquadsIndex];
                                        return Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.15),
                                          child: AllSquadTileWidget(
                                            key: Key(
                                                'Keyrww_${listAllSquadsIndex}_of_${listAllSquads.length}'),
                                          ),
                                        );
                                      },
                                    );
                                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
