import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'take_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_display.dart';




class QandAPage extends StatelessWidget {
  // const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'よくある質問',
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
                  title: Text(
                    'このアプリはBeReal.を楽しむことをサポートするものです。\nまた当アプリは、BeReal.の独創的なアイデアを尊重しており、BeReal.が発明したアイデアを保護するため、当アプリでは撮影後の画像データの保存・スクショは一切できません。保存したい場合は、BeReal.アプリでベストショットの撮影に挑戦してみてください！',
                  ),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('X'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchDeveloperX('twitter://user?id=suupusoup', secondUrl: 'https://x.com/suupusoup');
                  },
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
    fontWeight: FontWeight.bold,
  );
}

class SettingValueTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}