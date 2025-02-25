import 'package:berehearsal/components/comp_settings_appbar.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:berehearsal/start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../settings_qa_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:berehearsal/components/comp_check_text.dart';
import 'package:berehearsal/functions/function_launch_url.dart';
import 'package:berehearsal/settings/use_packages_page/use_packages_data.dart';



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
            // --------------------- 使用パッケージ・バージョン ---------------------
            SettingsSection(
              title: const Text(
                '使用パッケージ・バージョン',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              ),
              tiles: [for (var item in usePackagesData)
                SettingsTile.navigation(
                  title: Text(
                    item['name'] ?? '',
                    style: const TextStyle(fontSize: 18)
                  ),
                  value: Text(
                    item['version'] ?? '',
                    style: const TextStyle(fontSize: 18)
                  ),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl(item['url'] ?? '');
                  },
                ),
              ],
            ),
            // ------------------------------------------------------------------
            // --------------------- 使用パッケージ・バージョン ---------------------
            SettingsSection(
              title: const Text(
                'ライセンス',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              ),
              tiles: [for (var item in usePackagesData)
                SettingsTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('[${item['name'] ?? ''}]', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(item['licence'] ?? '', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            )
            // ------------------------------------------------------------------
          ],
        ),
      )
    );
  }
}
