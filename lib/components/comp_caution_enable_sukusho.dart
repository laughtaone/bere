import 'package:flutter/material.dart';



class CautionEnableSukusho extends StatelessWidget {
  const CautionEnableSukusho({
    super.key,
    this.customTBPadding = 0
  });

  final double customTBPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customTBPadding),
      child: const Text(
        '画像の保存・スクショは一切できません',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}