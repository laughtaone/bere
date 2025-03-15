import 'package:flutter/material.dart';


class CompSettingsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CompSettingsAppbar({super.key,
    required this.leftHandedMode,
    required this.icon,
    required this.text,
    this.customActionIcon = Icons.close,
    this.customActionIconSize = 30
  });

  final IconData icon;
  final String text;
  final bool leftHandedMode;
  final IconData customActionIcon;
  final double customActionIconSize;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: (!leftHandedMode)
        ? [IconButton(
          icon: Icon(customActionIcon, size: customActionIconSize),
          onPressed: () => Navigator.pop(context)
        )]
        : null,
      leading: (leftHandedMode)
        ? IconButton(
          icon: Icon(customActionIcon, size: customActionIconSize),
          onPressed: () => Navigator.pop(context)
        )
        : null,
      automaticallyImplyLeading: false,
    );
  }
}