import 'package:berehearsal/components/comp_caution_enable_sukusho.dart';
import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_common_body_column.dart';
import 'package:berehearsal/components/comp_loading.dart';
import 'package:berehearsal/components/comp_setting_button.dart';
import 'package:berehearsal/components/comp_take_display_icon.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'confirm_page.dart';
import 'dart:math' as math;



class TakePage extends StatefulWidget {
  const TakePage({super.key});

  @override
  TakePageState createState() => TakePageState();
}

class TakePageState extends State<TakePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _cameraIndex = 0;     // 0:外カメラ・1:内カメラ
  String? mainImagePath;
  String? subImagePath;
  bool isTaking = false;
  bool leftHandedMode = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    firstSettingLoad();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[_cameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();

    // フラッシュをオフに設定
    await _initializeControllerFuture;
    await _controller!.setFlashMode(FlashMode.off);

    if (mounted) {
      setState(() {});
    }
  }

  // 設定値読み込み
  Future<void> firstSettingLoad() async {
    setState(() async {
      leftHandedMode = await loadLeftHandedModePreference() ?? false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));  // 0.1秒待機
      setState(() {
        isTaking = true;
      });
      await _initializeControllerFuture;

      // ------------------- メイン画像を撮影 -------------------
      final mainImage = await _controller!.takePicture();
      mainImagePath = mainImage.path;
      if (!mounted) return;
      // -----------------------------------------------------

      // -------------------- カメラ切り替え --------------------
      if (_cameraIndex == 0) {
        _cameraIndex = 1;
      } else {
        _cameraIndex = 0;
      }
      // -----------------------------------------------------

      // -------------------- サブ画像を撮影 --------------------
      await _initializeCamera();
      await _initializeControllerFuture; // 初期化が完了するまで待機
      await Future.delayed(const Duration(milliseconds: 400));  // 0.4秒待機
      final subImage = await _controller!.takePicture();
      subImagePath = subImage.path;

      // 両方のカメラで撮影完了後にConfirmPageに遷移
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPage(
              mainImagePath: mainImagePath ?? '',
              subImagePath: subImagePath ?? ''
            ),
          ),
        );
      }
      // -----------------------------------------------------

      // ---------------- カメラの内/外を元に戻す ----------------
      if (_cameraIndex == 0) {
        _cameraIndex = 1;
      } else {
        _cameraIndex = 0;
      }
      await _initializeCamera();
      // -----------------------------------------------------
    } catch (e) {
      debugPrint('$e');
    } finally {
      setState(() {
        isTaking = false;
      });
    }
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
        appBar: CompCommonAppbar(
          isCompactDisplay: isCompactDisplay,
          callbackOpenSettingPage: (bool recvBool) async {
            if (recvBool) {
              bool keepleftHandedMode = await loadLeftHandedModePreference() ?? false;
              setState(() {
                leftHandedMode = keepleftHandedMode;
              });
            }
          }
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            bool isPrepaired = snapshot.connectionState == ConnectionState.done;

            return CompCommonBodyColumn(
              isCompactDisplay: isCompactDisplay,
              needBottomPadding: false,
              // ================================================== カメラ画像部分 ===================================================
              centerElement: (isPrepaired)      // 準備が終えたかどうか
                ? (isTaking)
                  ? const AspectRatio(
                    aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                    child: CompLoading(
                      message: '撮影中...',
                    ),
                  )
                  : Stack(
                    children: [
                      // ------------------------- カメラ画像のContainer -------------------------
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: AspectRatio(
                            aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                            child: CameraPreview(_controller!),
                          ),
                        ),
                      // -----------------------------------------------------------------------
                      // ----------------------------- アイコン配置 ------------------------------
                      Positioned(
                        bottom: 1,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: (leftHandedMode)
                            ? [
                              // - - - - - フラッシュボタン - - - - -
                              const CompTakeDisplayIcon(
                                icon: Icons.electric_bolt_outlined,
                                onPressed: null,
                                customPadding: EdgeInsets.only(left: 7),
                              ),
                              // - - - - - - - - - - - - - - - - -
                              // - - - - - - 倍率ボタン - - - - - -
                              const CompTakeDisplayIcon(
                                icon: Icons.circle_outlined,
                                onPressed: null,
                              ),
                              // - - - - - - - - - - - - - - - - -
                              // - - イン/アウトカメラ切替ボタン - - -
                              CompTakeDisplayIcon(
                                icon: Icons.cached_outlined,
                                onPressed: () {
                                  HapticFeedback.lightImpact();     // 触覚フィードバック
                                  if (_cameraIndex == 0) {
                                    _cameraIndex = 1;
                                  } else {
                                    _cameraIndex = 0;
                                  }
                                  _initializeCamera();
                                },
                                customPadding: const EdgeInsets.only(right: 7),
                              ),
                              // - - - - - - - - - - - - - - - - -
                            ].reversed.toList()
                            : [
                              // - - - - - フラッシュボタン - - - - -
                              const CompTakeDisplayIcon(
                                icon: Icons.electric_bolt_outlined,
                                onPressed: null,
                                customPadding: EdgeInsets.only(left: 7),
                              ),
                              // - - - - - - - - - - - - - - - - -
                              // - - - - - - 倍率ボタン - - - - - -
                              const CompTakeDisplayIcon(
                                icon: Icons.circle_outlined,
                                onPressed: null,
                              ),
                              // - - - - - - - - - - - - - - - - -
                              // - - イン/アウトカメラ切替ボタン - - -
                              CompTakeDisplayIcon(
                                icon: Icons.cached_outlined,
                                onPressed: () {
                                  HapticFeedback.lightImpact();     // 触覚フィードバック
                                  if (_cameraIndex == 0) {
                                    _cameraIndex = 1;
                                  } else {
                                    _cameraIndex = 0;
                                  }
                                  _initializeCamera();
                                },
                                customPadding: const EdgeInsets.only(right: 7),
                              ),
                              // - - - - - - - - - - - - - - - - -
                            ],
                        ),
                      ),
                      // -----------------------------------------------------------------------
                    ],
                  )
                // ------------------------- カメラ切り替え中の表示 -------------------------
                : const AspectRatio(
                  aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                  child: CompLoading(
                    message: '準備中...',
                  ),
                ),
                // -----------------------------------------------------------------------
              // ===================================================================================================================
              // ==================================================== 撮影ボタン ====================================================
              bottomElement: LayoutBuilder(
                builder: (context, constraints) {
                  return IconButton(
                    style: IconButton.styleFrom(
                      disabledForegroundColor: Colors.white.withOpacity(0.15)
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: (constraints.maxHeight >= 100) ? 100 : constraints.maxHeight,       // アイコンサイズを利用可能なスペースに合わせる
                    icon: const Icon(Icons.radio_button_unchecked),
                    onPressed: (isPrepaired) ? _takePicture : null, // 準備中でなければ写真を撮る関数を呼び出し,
                  );
                },
              )
              // ===================================================================================================================
            );
          },
        ),
      ),
    );
  }
}

