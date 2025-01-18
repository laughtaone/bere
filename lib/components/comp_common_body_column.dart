import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:flutter/material.dart';




class CompCommonBodyColumn extends StatefulWidget {
  const CompCommonBodyColumn({
    super.key,
    required this.isCompactDisplay,
    required this.centerElement,
    required this.bottomElement,
    required this.needBottomPadding
  });

  final bool isCompactDisplay;
  final Widget centerElement;
  final LayoutBuilder bottomElement;
  final bool needBottomPadding;

  @override
  CompCommonBodyColumnState createState() => CompCommonBodyColumnState();
}

class CompCommonBodyColumnState extends State<CompCommonBodyColumn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // =================================== 注意書き(isCompactDisplayがfalseの場合のみ表示) ====================================
        (widget.isCompactDisplay)
          ? const SizedBox.shrink()
          : CautionEnableSukusho(customBottomPadding: (widget.needBottomPadding) ? 20 : 0),
        // ===================================================================================================================

        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // =============================================== 真ん中のカメラ画像部分 ===============================================
              widget.centerElement,
              // ===================================================================================================================


              // ================================================== 最下部のボタン ===================================================
              Flexible(
                child: widget.bottomElement
              ),
              // ===================================================================================================================
            ]
          ),
        ),
      ],
    );
  }
}
