import 'package:flutter/material.dart';

class CompTitleAppBar extends StatelessWidget {
  const CompTitleAppBar({super.key});
  // TextStyle commonTextStyle({required Color color}) {
  //   return TextStyle(
  //     fontFamily: 'Inter',
  //     fontWeight: FontWeight.bold,
  //     color: color,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 19),
            children: [
              TextSpan(text: "BeRe", style: TextStyle(color: Colors.white)),
              TextSpan(text: "hears", style: TextStyle(color: Color(0xffB6E6AF))),
              TextSpan(text: "al.", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const Text(
          'To support enjoying BeReal.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
