import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'take_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_protector/screen_protector.dart';


class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {

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
    bool skipStartPage = prefs.getBool('skipStartPage') ?? false;

    if (skipStartPage) {
      Future.microtask(() {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TakePage()),
          );
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // ------------------------- タイトル -------------------------
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
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // -----------------------------------------------------------

              const SizedBox(height: 230),

              // --------------------- 「はじめる」ボタン ---------------------
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)
                  )
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();     // 触覚フィードバック
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TakePage(),
                      fullscreenDialog: true
                    ),
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
              // -----------------------------------------------------------

              const SizedBox(height: 45),

              // ------------------------- 注意書き -------------------------
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.info_outline,
                      size: 22,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'このアプリはあくまでリハーサル用です',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '撮影した画像の保存・スクショは一切できません',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // -----------------------------------------------------------

              const SizedBox(height: 10),

              // ------------------------ 非公式案内 ------------------------
              const Text('BeReal.非公式アプリ', style: TextStyle(fontSize: 11, color: Color(0xffa0a0a0), fontWeight: FontWeight.bold)),
              // -----------------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
