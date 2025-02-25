import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_common_body_column.dart';
import 'package:berehearsal/components/comp_image_animation.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


// ConfirmPageの定義
class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key,
    required this.mainImagePath,
    required this.subImagePath,
    required this.leftHandedMode
  });

  final String mainImagePath;
  final String subImagePath;
  final bool leftHandedMode;


  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  bool isImageSwap = false;
  bool leftHandedMode = false;

  @override
  void initState() {
    super.initState();
    firstSettingLoad();
  }

  // 設定値読み込み
  Future<void> firstSettingLoad() async {
    setState(() async {
      // leftHandedMode = await loadLeftHandedModePreference() ?? false;
      leftHandedMode = widget.leftHandedMode;   // 設定値読み込み
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;     // 画面の高さを取得
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double bodyHeight = screenHeight - AppBar().preferredSize.height;

    bool isCompactDisplay = screenHeight < 743;       // 画面の高さが 743px未満 だったらコンパクト表示


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CompCommonAppbar(
          isCompactDisplay: isCompactDisplay,
          leftHandedMode: leftHandedMode
        ),
        body: CompCommonBodyColumn(
          isCompactDisplay: isCompactDisplay,
          needBottomPadding : true,
          // ================================================= カメラ画像部分 始 =================================================
          centerElement: Stack(
            children: [
              // ------------------------------- メイン画像 ------------------------------
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedImageSwitcher(
                    imagePath: (isImageSwap) ? widget.subImagePath : widget.mainImagePath,
                  ),
                ),
              ),
              // -----------------------------------------------------------------------
              // --------------------------- 右上の閉じるボタン ---------------------------
              Positioned(
                top: 10,
                right: (!leftHandedMode) ? 10 : null,
                left: (!leftHandedMode) ? null : 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withAlpha((0.5 * 255).round()),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                      size: 25,
                    ),
                  ),
                ),
              ),
              // -----------------------------------------------------------------------

              // ------------------------------- サブ画像 -------------------------------
              Positioned(
                top: 15,
                left: 15,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    side: const BorderSide(color: Colors.black, width: 1.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();     // 触覚フィードバック
                    setState(() {
                      isImageSwap = !isImageSwap;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 120,
                      child: AnimatedImageSwitcher(
                        imagePath: (isImageSwap)
                          ? widget.mainImagePath
                          : widget.subImagePath,
                      ),
                    ),
                  ),
                ),
              ),
              // -----------------------------------------------------------------------
            ],
          ),
          // ==================================================================================================================
          // ================================================= BeReal.開くボタン ================================================
          bottomElement: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    padding: const EdgeInsets.only(bottom: 15)
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();     // 触覚フィードバック
                    try {
                      final url = Uri.parse('bereal://');
                      if (!await launchUrl(url)) {
                        // URLが開けなかった場合のダイアログを表示
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('⚠️ エラー'),
                              content: const Text('BeReal.を開けませんでした。\nアプリがインストールされているか確認してください。\n\nインストール済みの場合は、お手数ですが手動で開いてください。'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      // URL解析エラーなどの例外処理
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('⚠️ エラー'),
                            content: const Text('BeReal.を開けませんでした。\nアプリがインストールされているか確認してください。\n\nインストール済みの場合は、お手数ですが手動で開いてください。'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'BeReal.を開く>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
              );
            },
          )
          // ===================================================================================================================
        )
      ),
    );
  }
}