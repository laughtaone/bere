import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'take_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';




class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '設定',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        automaticallyImplyLeading: false, // 戻るボタン非表示
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: Text(
                'このアプリについて',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile(
                  leading: const Icon(Icons.info),
                  title: const Text('アプリのバージョン'),
                  value: Text(
                    'aa',
                    style: SettingValueTextStyle.myTextStyle,
                  )
                )
              ],
            ),
            SettingsSection(
              title: Text(
                'Common',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('English'),
                  onPressed: (context) {
                    // 画面遷移処理
                  },
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    // トグル切り替え処理
                  },
                  initialValue: true,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Enable custom theme'),
                ),
              ],
            ),
            SettingsSection(
              title: Text(
                '開発者について',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.person),
                  title: const Text('X'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchDeveloperX('twitter://user?id=suupusoup', secondUrl: 'https://x.com/suupusoup');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.person),
                  title: const Text('TikTok'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) { _launchTikTok();},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  Future<void> _launchDeveloperX(String url, {String? secondUrl}) async {
    try {
      if (await canLaunchUrlString(url)) {
        final xURL = Uri.parse(url);
        await launchUrl(xURL);
      } else if (secondUrl != null && await canLaunchUrlString(secondUrl)) {
        await launchUrlString(secondUrl);
      } else {
        // 任意のエラー処理
      }
    } catch (e) {
      // エラーハンドリング
      print('エラーが発生しました: $e');
    }
  }

  Future _launchTikTok() async {
    final url = Uri.parse('https://www.tiktok.com/@suupusoup');
    launchUrl(url);
  }
}


class SettingTitleTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );
}

class SettingValueTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}