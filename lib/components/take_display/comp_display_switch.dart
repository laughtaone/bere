import 'package:flutter/material.dart';



class CompDisplaySwitch extends StatelessWidget {
  const CompDisplaySwitch(this.displayText, {super.key});
  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xff111111).withAlpha((0.55 * 255).round()),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(displayText, style: const TextStyle(fontSize: 15))
    );
  }
}