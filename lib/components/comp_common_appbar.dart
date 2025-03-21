import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:berehearsal/components/comp_setting_button.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';
import 'package:flutter/material.dart';




class CompCommonAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CompCommonAppbar({super.key,
    required this.isCompactDisplay,
    required this.leftHandedMode,
    this.customOnPressed
  });

  final bool isCompactDisplay;
  final bool leftHandedMode;
  final void Function()? customOnPressed;

  @override
  CompCommonAppbarState createState() => CompCommonAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CompCommonAppbarState extends State<CompCommonAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: widget.isCompactDisplay ? CautionEnableSukusho(isCompactDisplay: widget.isCompactDisplay) : const CompTitleAppBar(),
      actions: (widget.leftHandedMode)
        ? [IconButton(
            onPressed: (widget.customOnPressed == null)
              ? () => Navigator.pop(context)
              : widget.customOnPressed!,
            icon: const Icon(Icons.expand_more_outlined),
        )]
        : const [CompSettingButton()],
      leading: (widget.leftHandedMode)
        ? const CompSettingButton()
        : IconButton(
          onPressed: (widget.customOnPressed == null)
              ? () => Navigator.pop(context)
              : widget.customOnPressed!,
          icon: const Icon(Icons.expand_more_outlined),
        )
    );
  }
}
