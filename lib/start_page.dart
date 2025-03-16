import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_language_button.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:berehearsal/settings/settings_language_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'take_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  bool leftHandedMode = false;

  @override
  void initState() {
    super.initState();
    firstLoad();
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
            MaterialPageRoute(builder: (context) => TakePage(leftHandedMode: leftHandedMode)),
          );
        }
      });
    }
  }

  Future<void> firstLoad() async {
    final bool keepLeftHandedMode = await loadLeftHandedModePreference() ?? false;   // 設定値読み込み
    setState(() {
      leftHandedMode = keepLeftHandedMode;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;     // 画面の高さを取得
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double bodyHeight = screenHeight - AppBar().preferredSize.height;     // 本体の高さを取得

    return Scaffold(
      // ------------------------- AppBar -------------------------
      appBar: AppBar(
        actions: (leftHandedMode)
          ? null
          : [CompLanguageButton(leftHandedMode: leftHandedMode)],
        leading: (leftHandedMode)
          ? CompLanguageButton(leftHandedMode: leftHandedMode)
          : null,
      ),
      // -----------------------------------------------------------
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: bodyHeight * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ------------------------- タイトル -------------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 3),
                    // - - - - メインタイトル - - - -
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
                    // - - - - - - - - - - - - -
                    // - - - - サブタイトル - - - -
                    const Text(
                      'To support enjoying BeReal.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // - - - - - - - - - - - - -
                    const SizedBox(height: 10),
                    // - - - - 非公式案内 - - - -
                    Text(
                      AppLocalizations.of(context)!.berealUnofficialApp,
                      style: const TextStyle(fontSize: 14, color: Color(0xffd0d0d0), fontWeight: FontWeight.bold)
                    ),
                    // - - - - - - - - - - - - -
                  ],
                ),
                // -----------------------------------------------------------
            
                // --------------------- 「はじめる」ボタン ---------------------
                Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)
                        ),
                        fixedSize: Size(screenWidth, 130),
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();     // 触覚フィードバック
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakePage(leftHandedMode: leftHandedMode),
                            fullscreenDialog: true
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.start,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 43,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.white,
                            size: 50,
                          )
                        ],
                      ),
                    ),
                    // -----------------------------------------------------------
            
                    // ------------------------- 注意書き -------------------------
                    Container(
                      width: screenWidth * 0.85,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.info_outline,
                              size: 22,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.thisAppIsForRehearsalsOnly,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.cannotSaveImages,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // -----------------------------------------------------------
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
