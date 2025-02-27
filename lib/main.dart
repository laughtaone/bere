import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berehearsal/settings/settings_display.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/start_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面の向きを縦に固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 縦向き（標準）
  ]);

  final prefs = await SharedPreferences.getInstance();
  // 初回起動時に 'skipStartPage' が設定されていない場合、false に設定
  if (!prefs.containsKey('skipStartPage')) {
    await prefs.setBool('skipStartPage', false);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsPageModel(),
      child: const StartPageHome(),
    ),
  );
}

class StartPageHome extends StatelessWidget {
  const StartPageHome({super.key});

  @override
  Widget build(BuildContext context) {
    Color commonBackColor = const Color(0xff1E1E1E);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: commonBackColor, // 背景色
        appBarTheme: AppBarTheme(
          backgroundColor: commonBackColor,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),   // デフォルトの文字色
          iconTheme: const IconThemeData(
            color: Colors.white, // デフォルトのアイコン色
            size: 25
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // デフォルトのアイコン色
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),   // デフォルトの文字色
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.2); // 押した時の色
                }
                return null; // デフォルトの色を使用
              },
            ),
          ),
        ),
      ),
      home: const StartPage(),
    );
  }
}
