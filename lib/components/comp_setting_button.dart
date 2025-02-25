import 'package:berehearsal/settings/settings_display.dart';
import 'package:flutter/material.dart';




// 設定ボタンの内容
class CompSettingButton extends StatefulWidget {
  const CompSettingButton({super.key,
  });

  @override
  CompSettingButtonState createState() => CompSettingButtonState();
}

class CompSettingButtonState extends State<CompSettingButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Navigator.push(
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
