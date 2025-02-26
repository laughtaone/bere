import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_common_body_column.dart';
import 'package:berehearsal/components/comp_image_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';


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
  bool isOnlyMainImage = false;
  double subMaterialOpacity = 1;
  double mainImageScale = 1.0;
  double mainBaseScale = 1.0;
  Offset focalPoint = Offset.zero; // 指の初期タッチ位置
  Offset baseOffset = Offset.zero; // 移動前のオフセット
  Offset currentOffset = Offset.zero; // 現在のオフセット
  bool isPressedCloseButton = false;
  ImageFilter filteredCond = ImageFilter.blur(sigmaX: 0, sigmaY: 0);


  final int secChangeSubMaterialOpacity = 100;    // サブ素材の透過度を変更する時間（ms）
  final double imageBorderRadius = 16;

  @override
  void initState() {
    super.initState();
    firstSettingLoad();
  }

  // 設定値読み込み
  Future<void> firstSettingLoad() async {
    leftHandedMode = widget.leftHandedMode;   // 設定値読み込み
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;     // 画面の高さを取得
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
                child: GestureDetector(
                  onLongPressStart: (_) async {
                    setState(() {
                      subMaterialOpacity = 0;
                    });
                    await Future.delayed(Duration(milliseconds: secChangeSubMaterialOpacity));
                    setState(() {
                      isOnlyMainImage = true;
                    });
                  },
                  onLongPressEnd: (_) async {
                    setState(() {
                      subMaterialOpacity = 1;
                    });
                    await Future.delayed(Duration(milliseconds: secChangeSubMaterialOpacity));
                    setState(() {
                      isOnlyMainImage = false;
                    });
                  },
                  onScaleStart: (details) {
                    mainBaseScale = mainImageScale;
                    focalPoint = details.focalPoint; // 指の開始位置を記録
                    baseOffset = currentOffset;
                  },
                  onScaleUpdate: (details) async {
                    setState(() {
                      mainImageScale = (mainBaseScale * details.scale).clamp(1.0, 5.0);
                      // 拡大時の指の位置に応じてオフセットを調整
                      final dx = (details.focalPoint.dx - focalPoint.dx) * mainImageScale;
                      final dy = (details.focalPoint.dy - focalPoint.dy) * mainImageScale;
                      currentOffset = Offset(baseOffset.dx + dx, baseOffset.dy + dy);
                    });
                    setState(() {
                      isOnlyMainImage = true;
                    });
                  },
                  onScaleEnd: (_) async {
                    setState(() {
                      mainImageScale = 1.0; // 指を離したら元のサイズに戻す
                      currentOffset = Offset.zero; // 位置もリセット
                    });
                    setState(() {
                      isOnlyMainImage = false;
                    });
                  },
                  child: ImageFiltered(
                    imageFilter: filteredCond,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(imageBorderRadius),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: currentOffset, // 指の位置に合わせたオフセットを適用
                            child: Transform.scale(
                              scale: mainImageScale,
                              child: ClipRRect( // ここで適用する
                                borderRadius: BorderRadius.circular(imageBorderRadius),
                                child: Image.asset(
                                  isImageSwap ? widget.subImagePath : widget.mainImagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ),
              // -----------------------------------------------------------------------
              // --------------------------- 右上の閉じるボタン ---------------------------
              (!isOnlyMainImage)
                ? Positioned(
                  top: 10,
                  right: (!leftHandedMode) ? 10 : null,
                  left: (!leftHandedMode) ? null : 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () async{
                      setState(() {
                        isPressedCloseButton = true;
                        filteredCond = ImageFilter.blur(sigmaX: 16, sigmaY: 16);
                      });
                      await Future.delayed(const Duration(milliseconds: 700));
                      Navigator.pop(context);
                    },
                    child: ImageFiltered(
                      imageFilter: filteredCond,
                      child: AnimatedOpacity(
                        opacity: subMaterialOpacity,
                        duration: Duration(milliseconds: secChangeSubMaterialOpacity),
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
                  ),
                )
                : const SizedBox(),
              // -----------------------------------------------------------------------

              // ------------------------------- サブ画像 -------------------------------
              (!isOnlyMainImage)
                ? Positioned(
                  top: 15,
                  right: (!leftHandedMode) ? null : 15,
                  left: (!leftHandedMode) ? 15 : null,
                  child: ImageFiltered(
                    imageFilter: filteredCond,
                    child: AnimatedOpacity(
                      opacity: subMaterialOpacity,
                      duration: Duration(milliseconds: secChangeSubMaterialOpacity),
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
                  ),
                )
                : const SizedBox(),
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
                    'BeReal.様を開く>',
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