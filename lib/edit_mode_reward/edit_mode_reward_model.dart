import '/components/item_equipped_widget.dart';
import '/components/item_owned_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'edit_mode_reward_widget.dart' show EditModeRewardWidget;
import 'package:flutter/material.dart';

class EditModeRewardModel extends FlutterFlowModel<EditModeRewardWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ItemEquipped component.
  late ItemEquippedModel itemEquippedModel1;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel1;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel2;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel3;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel4;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel5;
  // Model for ItemEquipped component.
  late ItemEquippedModel itemEquippedModel2;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel6;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel7;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel8;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel9;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel10;
  // Model for ItemEquipped component.
  late ItemEquippedModel itemEquippedModel3;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel11;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel12;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel13;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel14;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel15;

  @override
  void initState(BuildContext context) {
    itemEquippedModel1 = createModel(context, () => ItemEquippedModel());
    itemOwnedModel1 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel2 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel3 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel4 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel5 = createModel(context, () => ItemOwnedModel());
    itemEquippedModel2 = createModel(context, () => ItemEquippedModel());
    itemOwnedModel6 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel7 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel8 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel9 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel10 = createModel(context, () => ItemOwnedModel());
    itemEquippedModel3 = createModel(context, () => ItemEquippedModel());
    itemOwnedModel11 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel12 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel13 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel14 = createModel(context, () => ItemOwnedModel());
    itemOwnedModel15 = createModel(context, () => ItemOwnedModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    itemEquippedModel1.dispose();
    itemOwnedModel1.dispose();
    itemOwnedModel2.dispose();
    itemOwnedModel3.dispose();
    itemOwnedModel4.dispose();
    itemOwnedModel5.dispose();
    itemEquippedModel2.dispose();
    itemOwnedModel6.dispose();
    itemOwnedModel7.dispose();
    itemOwnedModel8.dispose();
    itemOwnedModel9.dispose();
    itemOwnedModel10.dispose();
    itemEquippedModel3.dispose();
    itemOwnedModel11.dispose();
    itemOwnedModel12.dispose();
    itemOwnedModel13.dispose();
    itemOwnedModel14.dispose();
    itemOwnedModel15.dispose();
  }
}
