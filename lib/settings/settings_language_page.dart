// 言語設定画面
import 'package:berehearsal/components/comp_settings_appbar.dart';
import 'package:berehearsal/functions/function_code_to_language.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Icon checkIcon = const Icon(Icons.check, color: Colors.blue);


class SettingsLanguagePage extends StatefulWidget {
  const SettingsLanguagePage({super.key,
    this.isFullScreen = false,
    this.isLeftHandedMode = true
  });

  final bool isFullScreen;
  final bool isLeftHandedMode;

  @override
  SettingsLanguagePageState createState() => SettingsLanguagePageState();
}

class SettingsLanguagePageState extends State<SettingsLanguagePage> {
  final List<String> languageList = ['ja', 'en', 'fr', 'de', 'ko', 'zh', 'es', 'it', 'pt'];


  @override
  Widget build(BuildContext context) {
    final String language = Provider.of<LanguageProvider>(context).locale.toString().split('.').last;
    return Scaffold(
      appBar: CompSettingsAppbar(
        leftHandedMode: widget.isLeftHandedMode,
        icon: Icons.language_outlined,
        text: AppLocalizations.of(context)!.languageSettings,
        customActionIcon: (widget.isFullScreen) ? Icons.close : Icons.arrow_back_ios,
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.languageSettings),
              tiles: languageList.map((String languageCode) {
                if (languageList.length - 1 != languageList.indexOf(languageCode)) {
                  return SettingsTile(
                    title: Text((languageCode=='ja') ? '${codeToLanguage(languageCode)}（${AppLocalizations.of(context)!.defaultAndOriginalText}）' : codeToLanguage(languageCode)),
                    value: (language == languageCode)
                      ? checkIcon
                      : null,
                    onPressed: (_) async {
                      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                      await setLangugagePreference(languageCode);
                      languageProvider.setLanguage(languageCode);
                      setState(() {});
                    }
                  );
                } else {
                  return SettingsTile(
                    title: Text(codeToLanguage(languageCode)),
                    value: (language == languageCode)
                      ? checkIcon
                      : null,
                    onPressed: (_) async {
                      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                      await setLangugagePreference(languageCode);
                      languageProvider.setLanguage(languageCode);
                      setState(() {});
                    },
                    description: Text(AppLocalizations.of(context)!.descriptionLanguageSettingsPage)    // 末尾の説明文
                  );
                }
              }).toList(),
            ),
          ],
        ),
      )
    );
  }
}
