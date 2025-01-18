import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_common_body_column.dart';
import 'package:berehearsal/components/comp_image_animation.dart';
import 'package:berehearsal/components/comp_setting_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'take_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';


// ConfirmPageの定義
class ConfirmPage extends StatefulWidget {
  final String mainImagePath;
  final String subImagePath;

  const ConfirmPage({super.key, required this.mainImagePath, required this.subImagePath});

  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  bool isImageSwap = false;

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
          isCompactDisplay: isCompactDisplay
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
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.8),
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