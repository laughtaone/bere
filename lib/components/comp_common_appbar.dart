import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:berehearsal/components/comp_setting_button.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';
import 'package:flutter/material.dart';




class CompCommonAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CompCommonAppbar({super.key,
    required this.isCompactDisplay,
    required this.callbackOpenSettingPage
  });

  final bool isCompactDisplay;
  final void Function(bool) callbackOpenSettingPage;

  @override
  CompCommonAppbarState createState() => CompCommonAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Specify height
}

class CompCommonAppbarState extends State<CompCommonAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: widget.isCompactDisplay ? const CautionEnableSukusho() : const CompTitleAppBar(),
      actions: <Widget>[
        CompSettingButton(callbackOpenSettingPage: (bool recvBool) {
          widget.callbackOpenSettingPage(recvBool);
        },
      )],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.expand_more_outlined),
      ),
    );
  }
}
