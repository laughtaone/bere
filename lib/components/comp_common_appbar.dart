import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:berehearsal/components/comp_setting_button.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';
import 'package:flutter/material.dart';



class CompCommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CompCommonAppbar({super.key,
    required this.isCompactDisplay
  });

  final bool isCompactDisplay;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: (isCompactDisplay) ? const CautionEnableSukusho() : const CompTitleAppBar(),
      actions: const <Widget>[CompSettingButton()],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.expand_more_outlined)
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // 高さを指定
}