import 'package:berehearsal/components/comp_settings_appbar.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:berehearsal/start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_qa_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:berehearsal/components/comp_check_text.dart';
import 'package:berehearsal/functions/function_launch_url.dart';



class UsePackagesPage extends StatefulWidget {
  const UsePackagesPage({super.key,
    required this.leftHandedMode
  });

  final bool leftHandedMode;

  @override
  UsePackagesPageState createState() => UsePackagesPageState();
}



class UsePackagesPageState extends State<UsePackagesPage> {
  bool leftHandedMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      leftHandedMode = widget.leftHandedMode;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompSettingsAppbar(
        leftHandedMode: leftHandedMode,
        icon: Icons.book_outlined,
        text: '使用パッケージ',
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text(
                '開発者について',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.github),
                  title: const Text('GitHub'),
                  value: const Text('@laughtaone'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://www.github.com/laughtaone/');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.xTwitter),
                  title: const Text('X'),
                  value: const Text('@laughtaone'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://x.com/laughtaone/');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                  title: const Text('開発者 その他アプリ'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('');
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}




class SettingTitleTextStyle {
  static const TextStyle myTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

class SettingValueTextStyle {
  static const TextStyle myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}
