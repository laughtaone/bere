import 'package:berehearsal/settings/settings_display.dart';
import 'package:flutter/material.dart';




// 設定ボタンの内容
class CompSettingButton extends StatelessWidget {
  const CompSettingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
            fullscreenDialog: true,
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
