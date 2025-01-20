import 'package:flutter/material.dart';



class CompTakeDisplayIcon extends StatelessWidget {
  const CompTakeDisplayIcon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.customPadding = const EdgeInsets.all(0)
  });

  final IconData icon;
  final void Function()? onPressed;
  final EdgeInsetsGeometry customPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white.withOpacity(0.85),
          size: 27,
        ),
        onPressed: onPressed,
      ),
    );
  }
}