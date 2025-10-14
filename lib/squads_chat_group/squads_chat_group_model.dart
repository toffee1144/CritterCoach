import '/components/member_chat_group_bubble_widget.dart';
import '/components/ongoing_call_group_notification_widget.dart';
import '/components/system_chat_group_bubble_widget.dart';
import '/components/user_chat_group_bubble_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'squads_chat_group_widget.dart' show SquadsChatGroupWidget;
import 'package:flutter/material.dart';

class SquadsChatGroupModel extends FlutterFlowModel<SquadsChatGroupWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for OngoingCallGroupNotification component.
  late OngoingCallGroupNotificationModel ongoingCallGroupNotificationModel;
  // Model for MemberChatGroupBubble component.
  late MemberChatGroupBubbleModel memberChatGroupBubbleModel;
  // Model for UserChatGroupBubble component.
  late UserChatGroupBubbleModel userChatGroupBubbleModel;
  // Model for SystemChatGroupBubble component.
  late SystemChatGroupBubbleModel systemChatGroupBubbleModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    ongoingCallGroupNotificationModel =
        createModel(context, () => OngoingCallGroupNotificationModel());
    memberChatGroupBubbleModel =
        createModel(context, () => MemberChatGroupBubbleModel());
    userChatGroupBubbleModel =
        createModel(context, () => UserChatGroupBubbleModel());
    systemChatGroupBubbleModel =
        createModel(context, () => SystemChatGroupBubbleModel());
  }

  @override
  void dispose() {
    ongoingCallGroupNotificationModel.dispose();
    memberChatGroupBubbleModel.dispose();
    userChatGroupBubbleModel.dispose();
    systemChatGroupBubbleModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
