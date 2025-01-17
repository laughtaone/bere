import 'package:flutter/material.dart';



class CautionEnableSukusho extends StatelessWidget {
  const CautionEnableSukusho({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      '画像の保存・スクショは一切できません',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}