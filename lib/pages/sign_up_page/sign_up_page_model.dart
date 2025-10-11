import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_up_page_widget.dart' show SignUpPageWidget;
import 'package:flutter/material.dart';

class SignUpPageModel extends FlutterFlowModel<SignUpPageWidget> {
  ///  Local state fields for this page.

  bool acceptedPolicy = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 8) {
      return 'Requires at least 8 characters.';
    }
    if (val.length > 20) {
      return 'Maximum 20 characters allowed, currently ${val.length}.';
    }
    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Must start with a letter and can only contain letters, digits and - or _.';
    }
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 8) {
      return 'Requires at least 8 characters.';
    }
    if (val.length > 16) {
      return 'Maximum 16 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 8) {
      return 'Requires at least 8 characters.';
    }
    if (val.length > 16) {
      return 'Maximum 16 characters allowed, currently ${val.length}.';
    }
    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Must start with a letter and can only contain letters, digits and - or _.';
    }
    return null;
  }

  // State field(s) for Switch widget.
  bool? switchValue;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    passwordVisibility = false;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
