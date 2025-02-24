import 'package:flutter/material.dart';



class CompDisplaySwitch extends StatelessWidget {
  const CompDisplaySwitch({super.key,
    required this.targetVeriable,
    required this.targetText,
    this.customOnText = 'オン',
    this.customOffText = 'オフ',
    this.customFullText = ''
  });

  final bool targetVeriable;
  final String targetText;
  final String customOnText;
  final String customOffText;
  final String customFullText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xff111111).withAlpha((0.55 * 255).round()),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        (customFullText.isNotEmpty)
          ? customFullText :
          '$targetTextが ${targetVeriable ? customOnText : customOffText} になりました',
        style: const TextStyle(fontSize: 15),
      )
    );
  }
}