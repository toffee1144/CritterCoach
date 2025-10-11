import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_shop_model.dart';
export 'item_shop_model.dart';

class ItemShopWidget extends StatefulWidget {
  const ItemShopWidget({super.key});

  @override
  State<ItemShopWidget> createState() => _ItemShopWidgetState();
}

class _ItemShopWidgetState extends State<ItemShopWidget> {
  late ItemShopModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemShopModel());
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
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SvgPicture.asset(
                    'assets/images/coins.svg',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.contain,
                    alignment: Alignment(0.0, 1.0),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Text(
                  '250',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ].divide(SizedBox(width: 5.0)),
          ),
        ),
      ),
    );
  }
}
