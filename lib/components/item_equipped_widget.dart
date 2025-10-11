import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_equipped_model.dart';
export 'item_equipped_model.dart';

class ItemEquippedWidget extends StatefulWidget {
  const ItemEquippedWidget({super.key});

  @override
  State<ItemEquippedWidget> createState() => _ItemEquippedWidgetState();
}

class _ItemEquippedWidgetState extends State<ItemEquippedWidget> {
  late ItemEquippedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemEquippedModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 121.0,
      decoration: BoxDecoration(
        color: Color(0xFFFFF69E),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.8),
        child: Text(
          'Equipped',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: Color(0xFF979797),
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ),
    );
  }
}
