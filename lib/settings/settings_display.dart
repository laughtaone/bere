import 'package:berehearsal/functions/function_code_to_language.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:berehearsal/settings/settings_language_page.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berehearsal/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';



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
    final String language = Provider.of<LanguageProvider>(context).locale.toString().split('.').last;
    return Scaffold(
      appBar: CompSettingsAppbar(
        leftHandedMode: leftHandedMode,
        icon: Icons.settings,
        text: AppLocalizations.of(context)!.settings
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            // ----------------------- スタート画面スキップ設定 -----------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.startScreen,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.directions_run_outlined),
                  title: Text(AppLocalizations.of(context)!.skipStartScreen),
                  description: Text(AppLocalizations.of(context)!.descriptionSkipStartScreen),
                  initialValue: skipStartPage,
                  onToggle: (value) async {
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
              title: Text(
                AppLocalizations.of(context)!.leftHandedMode,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.pan_tool_alt),
                  title: Text(AppLocalizations.of(context)!.turnOnLeftHandedMode),
                  description: Text(AppLocalizations.of(context)!.descriptionTurnOnLeftHandedMode),
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
                          title: Text(AppLocalizations.of(context)!.confirm),
                          content: Text(
                            AppLocalizations.of(context)!.descriptionAfterTurnOnLeftHandedMode,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                AppLocalizations.of(context)!.jumpTopPage,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.red)
                              ),
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
            // ------------------------------ 言語設定 ------------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.languageSettings,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(AppLocalizations.of(context)!.changeLanguageSettings),
                  value: Text(codeToLanguage(language)),
                  description: Text(AppLocalizations.of(context)!.descriptionLanguageSettings),
                  onPressed: (_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SettingsLanguagePage();
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ------------------------------ アプリ説明 ----------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.aboutThisApp,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CompCheckText(AppLocalizations.of(context)!.aboutThisAppContent1),
                      CompCheckText(AppLocalizations.of(context)!.aboutThisAppContent2),
                      CompCheckText(AppLocalizations.of(context)!.aboutThisAppContent3),
                      CompCheckText(AppLocalizations.of(context)!.aboutThisAppContent4)
                    ],
                  ),
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ----------------------------- よくある質問 ---------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.faq,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.contact_support),
                  title: Text(AppLocalizations.of(context)!.faq),
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
              title: Text(
                AppLocalizations.of(context)!.bugStatus,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: Text(AppLocalizations.of(context)!.currentlyConfirmedBugs),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/1a5b5b93908180eeb25cf2575515832c?pvs=4');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // -------------------------- 動作確認済み端末 ---------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.verifiedDevices,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.mobile_friendly_outlined),
                  title: Text(AppLocalizations.of(context)!.currentlyConfirmedDevices),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b9390818055b00ee12902fa819f?pvs=4');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ------------------------------ 本家様関連 ----------------------------
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.honkeApp, style: SettingTitleTextStyle.myTextStyle),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                  title: Text(AppLocalizations.of(context)!.appStoreTitle),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://apps.apple.com/jp/app/bereal-%E3%83%AA%E3%82%A2%E3%83%AB%E3%81%AA%E6%97%A5%E5%B8%B8%E3%82%92%E5%8F%8B%E9%81%94%E3%81%A8/id1459645446');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(AppLocalizations.of(context)!.officialWebsite),
                  value: const Text('https://bereal.com/jp/'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://bereal.com/ja/');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.xTwitter),
                  title: Text(AppLocalizations.of(context)!.officialX),
                  value: const Text('@BeReal_App'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://x.com/BeReal_App');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.instagram),
                  title: Text(AppLocalizations.of(context)!.officialInstagram),
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
              title: Text(
                AppLocalizations.of(context)!.aboutTheDeveloper,
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
                  leading:   SvgPicture.asset(
                    'assets/images/logo/zenn_logo.svg',
                    semanticsLabel: 'shopping',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(Color(0xffafafaf), BlendMode.srcIn)
                  ),
                  title: const Text('Zenn'),
                  value: const Text('@laughtaone'),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://zenn.dev/laughtaone');
                  },
                ),
                SettingsTile.navigation(
                  leading: const FaIcon(FontAwesomeIcons.appStoreIos),
                  title: Text(AppLocalizations.of(context)!.developerOtherApps),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://apps.apple.com/us/developer/taichi-usuba/id1798659459');
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // ---------------------------- アプリについて --------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.aboutTheApp,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(AppLocalizations.of(context)!.termsOfService),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b93908180738f1fc4e24974e0a9?pvs=4');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
                  onPressed: (BuildContext context) async {
                    await functionLaunchUrl('https://laughtaone.notion.site/BeRehearsal-1a5b5b9390818009acd9ff8e2ba76998?pvs=4');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.book_outlined),
                  title: Text(AppLocalizations.of(context)!.package),
                  onPressed: (BuildContext context)  {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => UsePackagesPage(leftHandedMode: leftHandedMode)
                    ));
                  },
                ),
              ],
            ),
            // --------------------------------------------------------------------
            // -------------------------- アプリバージョン ---------------------------
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.appVersion,
                style: SettingTitleTextStyle.myTextStyle,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.tag_outlined),
                  title: Text(AppLocalizations.of(context)!.appVersion),
                  value: const Text('1.1.1'),
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
