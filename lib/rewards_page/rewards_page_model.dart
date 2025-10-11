import '/components/item_owned_widget.dart';
import '/components/item_shop_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'rewards_page_widget.dart' show RewardsPageWidget;
import 'package:flutter/material.dart';

class RewardsPageModel extends FlutterFlowModel<RewardsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel1;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel1;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel2;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel2;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel3;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel4;
  // Model for ItemOwned component.
  late ItemOwnedModel itemOwnedModel3;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel5;
  // Model for ItemShop component.
  late ItemShopModel itemShopModel6;

  @override
  void initState(BuildContext context) {
    itemOwnedModel1 = createModel(context, () => ItemOwnedModel());
    itemShopModel1 = createModel(context, () => ItemShopModel());
    itemShopModel2 = createModel(context, () => ItemShopModel());
    itemOwnedModel2 = createModel(context, () => ItemOwnedModel());
    itemShopModel3 = createModel(context, () => ItemShopModel());
    itemShopModel4 = createModel(context, () => ItemShopModel());
    itemOwnedModel3 = createModel(context, () => ItemOwnedModel());
    itemShopModel5 = createModel(context, () => ItemShopModel());
    itemShopModel6 = createModel(context, () => ItemShopModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    itemOwnedModel1.dispose();
    itemShopModel1.dispose();
    itemShopModel2.dispose();
    itemOwnedModel2.dispose();
    itemShopModel3.dispose();
    itemShopModel4.dispose();
    itemOwnedModel3.dispose();
    itemShopModel5.dispose();
    itemShopModel6.dispose();
  }
}
