import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'settings_qa_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class SettingsPageModel extends ChangeNotifier {
  bool _skipStartPage = false;

  bool get skipStartPage => _skipStartPage;

  void setStartPageSkipTrue() {
    _skipStartPage = true;
    notifyListeners();
  }

  void setStartPageSkipFalse() {
    _skipStartPage = false;
    notifyListeners();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  bool _skipStartPage = false;

  @override
  void initState() {
    super.initState();
    _loadSkipStartPagePreference();
  }

  Future<void> _loadSkipStartPagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _skipStartPage = prefs.getBool('skipStartPage') ?? false;
    });
  }

  Future<void> _setSkipStartPagePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipStartPage', value);
    setState(() {
      _skipStartPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings),
            SizedBox(width: 5),
            Text(
              '設定',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text(
                'スタート画面',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.directions_run_outlined),
                  title: const Text('スタート画面をスキップする'),
                  description:
                      const Text('このスイッチをオンにすると、立ち上げ時にスタート画面をスキップし、いきなり撮影画面に進みます。'),
                  initialValue: _skipStartPage,
                  onToggle: (value) {
                    debugPrint(value ? 'スイッチがオンになりました' : 'スイッチがオフになりました');
                    _setSkipStartPagePreference(value);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                'このアプリについて',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pointList(
                          pointListText:
                              '本アプリはBeReal.さまに許可をいただいて作成したアプリではない、非公式のBeReal.リハーサルアプリです。'),
                      pointList(
                          pointListText:
                              '本アプリで撮影した写真を、保存・スクショすることは一切できません。これは、BeRehearsal.で撮影した画像とBeReal.で撮影した画像の見分けが付かず、BeReal.で撮影する楽しみを奪ってしまうことを防ぐためです。'),
                      pointList(
                          pointListText:
                              'スクショ・画面収録を防ぐため、マルチタスク画面が黒くなっていますが、再度本アプリを開けば元に戻りますので、ご安心ください。'),
                      pointList(
                          pointListText:
                              '本アプリは、あくまで開発者が「n回の再撮影」と表示されずに、BeReal.の撮影の練習をしたいという目的で開発したアプリです。'),
                    ],
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                'よくある質問',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('よくある質問'),
                  // value: const Text(''),
                  onPressed: (context) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const QAPage(),
                    ));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text(
                'バグ状況',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('現在確認しているバグ'),
                  onPressed: (BuildContext context) {
                    _launchBug();
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text('本家様', style: SettingTitleTextStyle.myTextStyle),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                  title: const Text('AppStore ページ'),
                  onPressed: (BuildContext context) {
                    _launchBeRealAppStore();
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('公式サイト'),
                  value: const Text('https://bereal.com/jp/'),
                  onPressed: (BuildContext context) {
                    _launchBeRealSite();
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.xTwitter),
                  title: const Text('公式X'),
                  value: const Text('@BeReal_App'),
                  onPressed: (BuildContext context) {
                    _launchBeRealX();
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.instagram),
                  title: const Text('公式Instagram'),
                  value: const Text('@bereal'),
                  onPressed: (BuildContext context) {
                    _launchBeRealInstagram();
                  },
                ),
              ],
            ),
            /*
            SettingsSection(
              title: const Text(
                '開発者について',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.xTwitter),
                  title: const Text('X'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchDeveloperX('twitter://user?id=suupusoup',
                        secondUrl: 'https://x.com/suupusoup');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.tiktok),
                  title: const Text('TikTok'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchTikTok();
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.youtube),
                  title: const Text('YouTube'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchYouTube();
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.instagram),
                  title: const Text('Instagram'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchInstagram();
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.github),
                  title: const Text('GitHub'),
                  value: const Text('@suupusoup'),
                  onPressed: (BuildContext context) {
                    _launchGitHub();
                  },
                ),
              ],
            ),
            */
            SettingsSection(
              title: const Text(
                'アプリについて',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('利用規約'),
                  onPressed: (BuildContext context) {
                    _launchTerms();
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('プライバシーポリシー'),
                  onPressed: (BuildContext context) {
                    _launchPrivacyPolcy();
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('使用ドキュメント'),
                  onPressed: (BuildContext context) {
                    _launchPrivacyPolcy();
                  },
                ),
              ],
            ),
          ],
        ),
      )
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
}

Future _launchBug() async {
  final url = Uri.parse(
      'https://suupusoup.notion.site/9ae018acb8624c7c9c3dacaa5c7b21a0?pvs=4');
  launchUrl(url);
}

Future _launchBeRealAppStore() async {
  final url = Uri.parse(
      'https://apps.apple.com/jp/app/bereal-%E3%83%AA%E3%82%A2%E3%83%AB%E3%81%AA%E6%97%A5%E5%B8%B8%E3%82%92%E5%8F%8B%E9%81%94%E3%81%A8/id1459645446');
  launchUrl(url);
}

Future _launchBeRealX() async {
  final url = Uri.parse('https://x.com/BeReal_App');
  launchUrl(url);
}

Future _launchBeRealSite() async {
  final url = Uri.parse('https://bereal.com/ja/');
  launchUrl(url);
}

Future _launchBeRealInstagram() async {
  final url = Uri.parse('https://www.instagram.com/bereal/');
  launchUrl(url);
}

Future _launchTikTok() async {
  final url = Uri.parse('https://www.tiktok.com/@suupusoup');
  launchUrl(url);
}

Future _launchYouTube() async {
  final url = Uri.parse('https://www.youtube.com/@suupusoup');
  launchUrl(url);
}

Future _launchGitHub() async {
  final url = Uri.parse('https://www.github.com/suupusoup');
  launchUrl(url);
}

Future _launchInstagram() async {
  final url = Uri.parse('https://www.instagram.com/suupusoup');
  launchUrl(url);
}

Future _launchTerms() async {
  final url = Uri.parse(
      'https://suupusoup.notion.site/BeRehearsal-765e2ebe610544f78548304326bc8568?pvs=4');
  launchUrl(url);
}

Future _launchPrivacyPolcy() async {
  final url = Uri.parse(
      'https://suupusoup.notion.site/BeRehearsal-00b894722e0448909b3ee9d27d607a79?pvs=4');
  launchUrl(url);
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

class pointList extends StatelessWidget {
  final String pointListText;

  const pointList({
    super.key,
    required this.pointListText,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        pointListText,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
