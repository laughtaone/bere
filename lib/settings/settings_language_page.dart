// 言語設定画面
import 'package:berehearsal/components/comp_settings_appbar.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




Icon checkIcon = const Icon(Icons.check, color: Colors.blue);


class SettingsLanguagePage extends StatefulWidget {
  const SettingsLanguagePage({super.key});
  @override
  SettingsLanguagePageState createState() => SettingsLanguagePageState();
}

class SettingsLanguagePageState extends State<SettingsLanguagePage> {
  bool leftHandedMode = false;

  // ------------------------------- 多言語対応用 -------------------------------
  void changeLanguage(BuildContext context, String languageCode) async {
    // Locale newLocale = Locale(languageCode);

    // 言語を保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    // setState(() {
    //   Now_location = placeMark.locality ?? "現在地データなし";
    //   ref.read(useLanguage.notifier).state = languageCode;
    //   debugPrint('現在のlanguageCodeは、$languageCode');
    // });

    // StartPageHome.setLocale(context, newLocale);
    // Navigator.pop(context); // メニューを閉じる
  }
  // --------------------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    final String language = Provider.of<LanguageProvider>(context).locale.toString().split('.').last;
    return Scaffold(
      appBar: CompSettingsAppbar(
        leftHandedMode: true,
        icon: Icons.language_outlined,
        text: AppLocalizations.of(context)!.languageSettings,
        customActionIcon: Icons.arrow_back_ios_outlined
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.languageSettings),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: Text('日本語（${AppLocalizations.of(context)!.defaultText}）'),
                  value: (language == 'ja')
                    ? checkIcon
                    : null,
                  onPressed: (_) async {
                    final languageCode = Provider.of<LanguageProvider>(context, listen: false);
                    String? loadLanguageCode = await loadLangugagePreference();
                    languageCode.setLanguage(loadLanguageCode ?? 'ja');
                    // changeLanguage(context, 'ja');
                    setState(() {});
                  }
                ),
                SettingsTile(
                  title: const Text('English'),
                  value: (language == 'en')
                    ? checkIcon
                    : null,
                  onPressed: (_) async {
                    final languageCode = Provider.of<LanguageProvider>(context, listen: false);
                    String? loadLanguageCode = await loadLangugagePreference();
                    languageCode.setLanguage(loadLanguageCode ?? 'en');
                    // changeLanguage(context, 'ja');
                    setState(() {});
                  },
                  // ---------------------- 末尾の説明文 ----------------------
                  description: Text(AppLocalizations.of(context)!.descriptionLanguageSettingsPage),
                ),
              ]
            ),
          ],
        ),
      )
    );
  }
}
