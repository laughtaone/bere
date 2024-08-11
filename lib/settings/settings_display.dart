import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../one/take_display.dart';
import 'settings_qa_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:berehearsal/custom/custom.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/main.dart';

class SettingsPage extends StatefulWidget {
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
        backgroundColor: allBackgroundColor(),
        appBar: AppBar(
          backgroundColor: allBackgroundColor(),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                '設定',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
          automaticallyImplyLeading: false,
        ),
        body: Theme(
          data: ThemeData.dark(),
          child: SettingsList(
            platform: DevicePlatform.iOS,
            sections: [
              SettingsSection(
                title: Text(
                  'スタート画面',
                  style: SettingTitleTextStyle.myTextStyle,
                ),
                tiles: [
                  SettingsTile.switchTile(
                    leading: Icon(Icons.directions_run_outlined),
                    title: const Text('スタート画面をスキップする'),
                    description:
                        Text('このスイッチをオンにすると、立ち上げ時にスタート画面をスキップし、いきなり撮影画面に進みます。'),
                    initialValue: _skipStartPage,
                    onToggle: (value) {
                      print(value ? 'スイッチがオンになりました' : 'スイッチがオフになりました');
                      _setSkipStartPagePreference(value);
                    },
                  ),
                ],
              ),
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
                        pointList(
                            pointListText:
                                '本アプリはBeReal.さまに許可をいただいて作成したアプリではない、非公式のBeReal.リハーサルアプリです。'),
                        pointList(
                            pointListText:
                                '本アプリで撮影した写真を、保存・スクショすることは一切できません。これは、BeRehearsal.で撮影した画像とBeReal.で撮影した画像の見分けが付かず、BeReal.で撮影する楽しみを奪ってしまうことを防ぐためです。'),
                        pointList(
                            pointListText:
                                '本アプリは、あくまで開発者が「n回の再撮影」と表示されずに、BeReal.の撮影の練習をしたいという目的で開発したアプリです。'),
                        // pointList(pointListText: '今後、2アプリを見分けることができるようにしながら保存機能を実現するため、内側と外側で2枚の別々の画像で保存する機能の実装を検討しています！'),
                      ],
                    ),
                  ),
                  // SettingsTile.navigation(
                  //   leading: const Icon(Icons.contact_support),
                  //   title: const Text('よくある質問'),
                  //   // value: const Text(''),
                  //   onPressed: (context) {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (_) => QAPage(),
                  //     ));
                  //   },
                  // ),
                ],
              ),
              SettingsSection(
                title: Text(
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
                        builder: (_) => QAPage(),
                      ));
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: Text('本家様', style: SettingTitleTextStyle.myTextStyle),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                    title: Text('AppStore ページ'),
                    onPressed: (BuildContext context) {
                      _launchBeRealAppStore();
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language_outlined),
                    title: Text('公式サイト'),
                    value: const Text('https://bereal.com/jp/'),
                    onPressed: (BuildContext context) {
                      _launchBeRealSite();
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const FaIcon(FontAwesomeIcons.xTwitter),
                    title: Text('公式X'),
                    value: const Text('@BeReal_App'),
                    onPressed: (BuildContext context) {
                      _launchBeRealX();
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const FaIcon(FontAwesomeIcons.instagram),
                    title: Text('公式Instagram'),
                    value: const Text('@bereal'),
                    onPressed: (BuildContext context) {
                      _launchBeRealInstagram();
                    },
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
              SettingsSection(
                title: Text(
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
        ));
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
