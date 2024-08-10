import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../one/take_display.dart';
import 'settings_qa_display.dart';
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pointList(pointListText: '本アプリはBeReal.さまに許可をいただいて作成したアプリではない、非公式のBeReal.リハーサルアプリです。'),
                      pointList(pointListText: '本アプリで撮影した写真を、保存・スクショすることは一切できません。理由は、BeRehearsal.で撮影した画像とBeReal.で撮影した画像の見分けが付かず、BeReal.で撮影する楽しみを奪ってしまうことを防ぐためです。'),
                      // pointList(pointListText: '今後、2アプリを見分けることができるようにしながら保存機能を実現するため、内側と外側で2枚の別々の画像で保存する機能の実装を検討しています！'),
                    ],
                  ),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('よくある質問'),
                  // value: const Text(''),
                  onPressed: (context) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QAPage(),
                    ));
                  },
                ),
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
    fontWeight: FontWeight.bold,
  );
}

class SettingValueTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}



class pointList extends StatelessWidget {
  final String pointListText;

  const pointList({
    Key? key,
    required this.pointListText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          pointListText,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
