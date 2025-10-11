import '/components/current_plan_tile_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'planner_page_widget.dart' show PlannerPageWidget;
import 'package:flutter/material.dart';

class PlannerPageModel extends FlutterFlowModel<PlannerPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for CurrentPlanTile component.
  late CurrentPlanTileModel currentPlanTileModel1;
  // Model for CurrentPlanTile component.
  late CurrentPlanTileModel currentPlanTileModel2;
  // Model for CurrentPlanTile component.
  late CurrentPlanTileModel currentPlanTileModel3;

  @override
  void initState(BuildContext context) {
    currentPlanTileModel1 = createModel(context, () => CurrentPlanTileModel());
    currentPlanTileModel2 = createModel(context, () => CurrentPlanTileModel());
    currentPlanTileModel3 = createModel(context, () => CurrentPlanTileModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    currentPlanTileModel1.dispose();
    currentPlanTileModel2.dispose();
    currentPlanTileModel3.dispose();
  }
}
