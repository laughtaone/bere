import 'package:berehearsal/functions/function_setting.dart';
import 'package:berehearsal/start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_qa_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:berehearsal/components/comp_check_text.dart';
import 'package:berehearsal/functions/function_launch_url.dart';
import 'package:berehearsal/settings/use_packages_page/use_packages_page.dart';
import 'package:berehearsal/components/comp_settings_appbar.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
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

class SettingsPageState extends State<SettingsPage> {
  bool skipStartPage = false;
  bool leftHandedMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  // ----------------------------- 設定項目読み込み -----------------------------
  void loadSettings() async {
    bool keepSkipStartPage = await loadSkipStartPagePreference() ?? false;
    bool keepLeftHandedMode = await loadLeftHandedModePreference() ?? false;
    setState(() {
      skipStartPage = keepSkipStartPage;
      leftHandedMode = keepLeftHandedMode;
    });
  }
  // --------------------------------------------------------------------------



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompSettingsAppbar(
        leftHandedMode: leftHandedMode,
        icon: Icons.settings,
        text: '設定',
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            // ----------------------- スタート画面スキップ設定 -----------------------
            SettingsSection(
              title: const Text(
                'スタート画面',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.directions_run_outlined),
                  title: const Text('スタート画面をスキップする'),
                  description: const Text('このスイッチをオンにすると、立ち上げ時にスタート画面をスキップし、いきなり撮影画面に進みます。'),
                  initialValue: skipStartPage,
                  onToggle: (value) async {
                    debugPrint(value ? 'スイッチがオンになりました' : 'スイッチがオフになりました');
                    setSkipStartPagePreference(value);
                    bool keepSkipStartPage = await loadSkipStartPagePreference() ?? false;
                    setState(() {
                      skipStartPage = keepSkipStartPage;
                    });
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // --------------------------- 左利きモード設定 --------------------------
            SettingsSection(
              title: const Text(
                '左利きモード',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.pan_tool_alt),
                  title: const Text('左利きモードをオンにする'),
                  description: const Text('このスイッチをオンにすると、左利きの方にも使いやすいように、ほとんどのボタンの配置がデフォルトとは逆になります。'),
                  initialValue: leftHandedMode,
                  onToggle: (value) async {
                    setLeftHandedModePreference(value);
                    bool keepLeftHandedMode = await loadLeftHandedModePreference() ?? false;
                    setState(() {
                      leftHandedMode = keepLeftHandedMode;
                    });
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('確認'),
                          content: const Text(
                            '左利きモードの切り替えを反映するには、トップ画面に戻る必要があります\n\n次のボタンを押して\nトップ画面へ遷移してください',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('トップ画面へ遷移', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const StartPage()),
                                  (Route<dynamic> route) => false, // すべてのルートを削除
                                );
                              },
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ------------------------------ アプリ説明 ----------------------------
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
                      CompCheckText(text: '本アプリはBeReal.様に許可をいただいて作成したアプリではない、非公式のBeReal.リハーサルアプリです。'),
                      CompCheckText(text: '本アプリで撮影した写真を、保存・スクショすることは一切できません。\nこれは、BeRehearsal.とBeReal.の画像の見分けが付かず、BeReal.の楽しみを奪ってしまうことを防ぐためです。'),
                      CompCheckText(text: 'ホームに戻ろうとしたり、スクショや画面収録を行うと、画面は黒くなっていますが、通常通り使用する際には元に戻りますので、ご安心ください。'),
                      CompCheckText(text: '本アプリは、あくまで開発者が「n回の再撮影」と表示されずに、BeReal.の撮影の練習をしたいという目的で開発したアプリです。'),
                    ],
                  ),
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ----------------------------- よくある質問 ---------------------------
            SettingsSection(
              title: const Text(
                'よくある質問',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('よくある質問'),
                  onPressed: (context) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const QAPage(),
                    ));
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ------------------------------- バグ状況 ----------------------------
            SettingsSection(
              title: const Text(
                'バグ状況',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('現在確認しているバグ'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/1a5b5b93908180eeb25cf2575515832c?pvs=4');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // -------------------------- 動作確認済み端末 ---------------------------
            SettingsSection(
              title: const Text(
                '動作確認済み端末',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.mobile_friendly_outlined),
                  title: const Text('現在確認済みの端末'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b9390818055b00ee12902fa819f?pvs=4');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ------------------------------ 本家様関連 ----------------------------
            SettingsSection(
              title: const Text('本家様', style: SettingTitleTextStyle.myTextStyle),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                  title: const Text('AppStore ページ'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://apps.apple.com/jp/app/bereal-%E3%83%AA%E3%82%A2%E3%83%AB%E3%81%AA%E6%97%A5%E5%B8%B8%E3%82%92%E5%8F%8B%E9%81%94%E3%81%A8/id1459645446');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('公式サイト'),
                  value: const Text('https://bereal.com/jp/'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://bereal.com/ja/');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.xTwitter),
                  title: const Text('公式X'),
                  value: const Text('@BeReal_App'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://x.com/BeReal_App');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.instagram),
                  title: const Text('公式Instagram'),
                  value: const Text('@bereal'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://www.instagram.com/bereal/');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ---------------------------- 開発者について --------------------------
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
            // --------------------------------------------------------------------
            // ---------------------------- アプリについて --------------------------
            SettingsSection(
              title: const Text(
                'アプリについて',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('利用規約'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b93908180738f1fc4e24974e0a9?pvs=4');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('プライバシーポリシー'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b9390818009acd9ff8e2ba76998?pvs=4');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('使用パッケージ'),
                  onPressed: (BuildContext context)  {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => UsePackagesPage(leftHandedMode: leftHandedMode),
                      fullscreenDialog: true
                    ));
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // -------------------------- アプリバージョン ---------------------------
            SettingsSection(
              title: const Text(
                'アプリバージョン',
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.tag_outlined),
                  title: const Text('アプリバージョン'),
                  value: const Text('1.0'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b93908180e1a3add560fbcc066a?pvs=4');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
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
