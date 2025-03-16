import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berehearsal/settings/settings_display.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/start_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面の向きを縦に固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 縦向き（標準）
  ]);

  final prefs = await SharedPreferences.getInstance();

  // 初回起動時の設定
  if (!prefs.containsKey('skipStartPage')) {
    await prefs.setBool('skipStartPage', false);
  }

  // 言語設定の取得
  final String languageCode = prefs.getString('language') ?? 'ja';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsPageModel()),
        ChangeNotifierProvider(create: (context) => LanguageProvider(languageCode))
      ],
      child: const StartPageHome(),
    ),
  );
}


class StartPageHome extends StatefulWidget {
  const StartPageHome({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    Provider.of<LanguageProvider>(context, listen: false).setLanguage(newLocale.languageCode);
  }

  @override
  StartPageHomeState createState() => StartPageHomeState();
}

class StartPageHomeState extends State<StartPageHome> {
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LanguageProvider>(context).locale;

    Color commonBackColor = const Color(0xff1E1E1E);

    return MaterialApp(
      // ------------------- 多言語対応用 ------------------
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      // -------------------------------------------------
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: commonBackColor,
        appBarTheme: AppBarTheme(
          backgroundColor: commonBackColor,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const StartPage(),
    );
  }
}




class LanguageProvider extends ChangeNotifier {
  late Locale _locale;

  LanguageProvider(String? languageCode) {
    _locale = Locale(languageCode ?? 'ja'); // デフォは日本語
  }

  Locale get locale => _locale;

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners(); // UIを更新
    await saveLanguage(languageCode);
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }
}