import 'package:berehearsal/components/take_display/comp_display_switch.dart';
import 'package:berehearsal/components/take_display/comp_not_allowed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:berehearsal/components/comp_common_appbar.dart';
import 'package:berehearsal/components/comp_common_body_column.dart';
import 'package:berehearsal/components/comp_loading.dart';
import 'package:berehearsal/components/take_display/comp_take_display_icon.dart';
import 'package:berehearsal/functions/function_check_permission.dart';
import 'package:berehearsal/functions/function_setting.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:berehearsal/confirm_page.dart';



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
  bool isCameraAllowed = false;
  bool isMicAllowed = false;
  bool isFlashOn = false;
  bool isSwitchFlash = false;
  bool isSwitchCamera = false;
  bool isCameraMagnification = false;


  // ================================== 関数 ==================================
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    firstLoad();
  }

  // カメラの初期化
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

  // 初期読み込み
  Future<void> firstLoad() async {
    setState(() async {
      leftHandedMode = await loadLeftHandedModePreference() ?? false;   // 設定値読み込み
      isCameraAllowed = await functionCheckCameraPermission();          // カメラ権限確認
      isMicAllowed = await functionCheckMicPermission();                // マイク権限確認
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 撮影用関数
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

  // フラッシュ切り替え用関数
  Future switchFlash(isNowFlashOn) async {
    HapticFeedback.lightImpact();     // 触覚フィードバック
    if (isNowFlashOn) {
      _controller!.setFlashMode(FlashMode.off);
      setState(() {
        isFlashOn = false;
      });
    } else {
      _controller!.setFlashMode(FlashMode.always);
      setState(() {
        isFlashOn = true;
      });
    }

    setState(() {
      isSwitchFlash = true;
    });
    await Future.delayed(const Duration(milliseconds: 950));
    setState(() {
      isSwitchFlash = false;
    });
  }

  // カメラ切り替え用関数
  Future switchCamera(nowCameraIndex) async {
    HapticFeedback.lightImpact();     // 触覚フィードバック
    if (nowCameraIndex == 0) {
      _cameraIndex = 1;
    } else {
      _cameraIndex = 0;
    }
    _initializeCamera();

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isSwitchCamera = true;
    });
    await Future.delayed(const Duration(milliseconds: 950));
    setState(() {
      isSwitchCamera = false;
    });
  }

  // 倍率ボタン反映関数
  Future switchCameraMagnification() async {
    HapticFeedback.lightImpact();     // 触覚フィードバック

    setState(() {
      isCameraMagnification = true;
    });
    await Future.delayed(const Duration(milliseconds: 950));
    setState(() {
      isCameraMagnification = false;
    });
  }
  // =======================================================================




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
                ? (!isCameraAllowed || !isMicAllowed)     // カメラとマイクの権限が許可されていないかどうか
                  ? AspectRatio(
                      aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                      child: CompNotAllowed(
                        isCameraAllowed: isCameraAllowed,
                        isMicAllowed: isMicAllowed
                      ),
                  )
                  : (isTaking)
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
                          child: Column(
                            children: [
                              // ------------ 切り替え表示 ------------
                              // フラッシュ
                              (isSwitchFlash)
                                ? CompDisplaySwitch(targetVeriable: isFlashOn, targetText: 'フラッシュ')
                                : const SizedBox.shrink(),
                              // カメラ
                              (isSwitchCamera)
                                ? CompDisplaySwitch(targetVeriable: _cameraIndex==0 , targetText: 'カメラ', customOnText: '外カメラ', customOffText: '内カメラ')
                                : const SizedBox.shrink(),
                              // 倍率
                              (isCameraMagnification)
                                ? const CompDisplaySwitch(targetVeriable: false, targetText: '', customFullText: '現在開発中の機能のため、倍率は変更できません')
                                : const SizedBox.shrink(),
                              // ------------------------------------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: (leftHandedMode)
                                  ? [
                                    // - - - - - フラッシュボタン - - - - -
                                    CompFlashIcon(
                                      isFlashOn: isFlashOn,
                                      onPressed: (bool recvBool) {
                                        switchFlash(isFlashOn);
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                    // - - - - - - 倍率ボタン - - - - - -
                                    CompCameraMagnificationIcon(
                                      onPressed: (bool recvBool) {
                                        switchCameraMagnification();
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                    // - - イン/アウトカメラ切替ボタン - - -
                                    CompCameraIcon(
                                      cameraIndex: _cameraIndex,
                                      onPressed: (int recvInt) {
                                        switchCamera(recvInt);
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                  ].reversed.toList()
                                  : [
                                    // - - - - - フラッシュボタン - - - - -
                                    CompFlashIcon(
                                      isFlashOn: isFlashOn,
                                      onPressed: (bool recvBool) {
                                        switchFlash(isFlashOn);
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                    // - - - - - - 倍率ボタン - - - - - -
                                    CompCameraMagnificationIcon(
                                      onPressed: (bool recvBool) {
                                        switchCameraMagnification();
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                    // - - イン/アウトカメラ切替ボタン - - -
                                    CompCameraIcon(
                                      cameraIndex: _cameraIndex,
                                      onPressed: (int recvInt) {
                                        switchCamera(recvInt);
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                  ],
                              ),
                            ],
                          ),
                        ),
                        // -----------------------------------------------------------------------
                      ],
                    )
                // ------------------------- カメラ切り替え中の表示 -------------------------
                : const AspectRatio(
                  aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                  child: CompLoading(message: '準備中...')
                ),
                // -----------------------------------------------------------------------
              // ===================================================================================================================
              // ==================================================== 撮影ボタン ====================================================
              bottomElement: LayoutBuilder(
                builder: (context, constraints) {
                  return IconButton(
                    style: IconButton.styleFrom(
                      disabledForegroundColor: Colors.white.withAlpha((0.05 * 255).round())
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: (constraints.maxHeight >= 100) ? 100 : constraints.maxHeight,       // アイコンサイズを利用可能なスペースに合わせる
                    icon: const Icon(Icons.radio_button_unchecked),
                    onPressed: (isTaking || !isCameraAllowed || !isMicAllowed)
                      ? null
                      : (isPrepaired)
                        ? _takePicture     // 準備中かつ撮影中でなければ写真を撮る関数を呼び出せる
                        : null,
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

