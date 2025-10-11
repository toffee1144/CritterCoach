import '/components/ai_chat_bubble_widget.dart';
import '/components/user_chat_bubble_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ai_chat_page_widget.dart' show AiChatPageWidget;
import 'package:flutter/material.dart';

class AiChatPageModel extends FlutterFlowModel<AiChatPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AiChatBubble component.
  late AiChatBubbleModel aiChatBubbleModel1;
  // Model for UserChatBubble component.
  late UserChatBubbleModel userChatBubbleModel1;
  // Model for AiChatBubble component.
  late AiChatBubbleModel aiChatBubbleModel2;
  // Model for UserChatBubble component.
  late UserChatBubbleModel userChatBubbleModel2;
  // Model for AiChatBubble component.
  late AiChatBubbleModel aiChatBubbleModel3;

  @override
  void initState(BuildContext context) {
    aiChatBubbleModel1 = createModel(context, () => AiChatBubbleModel());
    userChatBubbleModel1 = createModel(context, () => UserChatBubbleModel());
    aiChatBubbleModel2 = createModel(context, () => AiChatBubbleModel());
    userChatBubbleModel2 = createModel(context, () => UserChatBubbleModel());
    aiChatBubbleModel3 = createModel(context, () => AiChatBubbleModel());
  }

  @override
  void dispose() {
    aiChatBubbleModel1.dispose();
    userChatBubbleModel1.dispose();
    aiChatBubbleModel2.dispose();
    userChatBubbleModel2.dispose();
    aiChatBubbleModel3.dispose();
  }
}
