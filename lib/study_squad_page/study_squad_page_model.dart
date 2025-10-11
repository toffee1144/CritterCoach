import '/components/my_squad_tile_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'study_squad_page_widget.dart' show StudySquadPageWidget;
import 'package:flutter/material.dart';

class StudySquadPageModel extends FlutterFlowModel<StudySquadPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MySquadTile component.
  late MySquadTileModel mySquadTileModel1;
  // Model for MySquadTile component.
  late MySquadTileModel mySquadTileModel2;

  @override
  void initState(BuildContext context) {
    mySquadTileModel1 = createModel(context, () => MySquadTileModel());
    mySquadTileModel2 = createModel(context, () => MySquadTileModel());
  }

  @override
  void dispose() {
    mySquadTileModel1.dispose();
    mySquadTileModel2.dispose();
  }
}
