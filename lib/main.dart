import 'package:flutter/material.dart';
import 'one/take_display.dart';
import 'package:berehearsal/custom/custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berehearsal/settings/settings_display.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  // 初回起動時に 'skipStartPage' が設定されていない場合、false に設定(設定するだけで、スタート画面のスキップの判断はここではしてない)
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
    return const MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _skipStartPage = false;

  @override
  void initState() {
    super.initState();
    // スクショ禁止機能
    ScreenProtector.preventScreenshotOn();
    ScreenProtector.protectDataLeakageWithColor(Colors.black);
    _checkSkipStartPage(); //スタート画面をスキップするかどうか判断する関数を呼び出す
  }

  @override
  void dispose() {
    // スクショ禁止機能
    super.dispose();
    ScreenProtector.preventScreenshotOff();
    ScreenProtector.protectDataLeakageWithColorOff();
  }

  // スタート画面をスキップするかどうか判断する関数(あくまで関数)
  Future<void> _checkSkipStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    bool skipStartPage =
        prefs.getBool('skipStartPage') ?? false; // ??は左側のやつがnullだった場合の処理を右側に書ける

    if (skipStartPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TakePage()),
        );
      });
    } else {
      setState(() {
        _skipStartPage = skipStartPage;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final settingsPageModel = Provider.of<SettingsPageModel>(context);
    if (settingsPageModel.skipStartPage == true) {
      return Container(); // 空のコンテナを返す
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: allBackgroundColor(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'BeRe', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'hears', style: TextStyle(color: Color(0xffB6E6AF))),
                          TextSpan(text: 'al.', style: TextStyle(color: Colors.white)),
                        ],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        )
                      ),
                    ),
                    const Text(
                      'To support enjoying BeReal.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 230),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TakePage()), // 画面遷移
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'はじめる',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.white,
                        size: 45,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'このアプリはあくまでリハーサル用です',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '撮影した画像の保存・スクショは一切できません',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0xffbbbbbb)
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text('BeReal.非公式アプリ', style: TextStyle(fontSize: 11, color: Color(0xffbbbbbb), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
