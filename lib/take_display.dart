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
import 'package:berehearsal/confirm_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class TakePage extends StatefulWidget {
  const TakePage({super.key,
    required this.leftHandedMode
  });

  final bool leftHandedMode;

  @override
  TakePageState createState() => TakePageState();
}

class TakePageState extends State<TakePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _cameraIndex = 0;
  String? mainImagePath;
  String? subImagePath;
  bool isTaking = false;
  bool isChangingCamera = false;
  bool leftHandedMode = false;
  bool isCameraAllowed = false;
  bool isMicAllowed = false;
  bool isFlashOn = false;
  bool isSwitchFlash = false;
  bool isSwitchCamera = false;
  bool isSwitchCameraRate = false;
  bool isCameraMagnification = false;
  bool isFirstLoaded = false;

  int? wideOutCameraIndex;
  int? normalOutCameraIndex;
  int? inCameraIndex;

  double _currentZoomLevel = 1.0; // 現在のズームレベル
  double _minZoomLevel = 1.0; // 最小ズームレベル
  double _maxZoomLevel = 5.0; // 最大ズームレベル
  double _baseZoom = 1.0;


    @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _initializeCamera();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }


    try {
      await firstLoad();
    } catch (e) {
      debugPrint('Error during firstLoad: $e');
    }
  }


  // カメラの初期化 (アプリ起動時)
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    // 超広角カメラを探す (built-in_video:5 を指定)
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == CameraLensDirection.back) {
        if (cameras[i].name.contains('built-in_video:5')) {
          wideOutCameraIndex = i;
          debugPrint('🔵 超広角カメラは、$i');
        } else if (cameras[i].name.contains('built-in_video:0')) {
          normalOutCameraIndex = i;
          debugPrint('🔵 通常カメラは、$i');
        }
      } else if (cameras[i].lensDirection == CameraLensDirection.front) {
        inCameraIndex = i;
        // debugPrint('🔵 インカメラは、$i');
      }
    }

    _controller = CameraController(
      cameras[normalOutCameraIndex ?? 0],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();

    await _initializeControllerFuture;
    await _controller!.setFlashMode(FlashMode.off);    // フラッシュを設定
    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);            // カメラの向きを縦に固定

    // ズームレベルの範囲を取得
    _minZoomLevel = await _controller!.getMinZoomLevel();
    _maxZoomLevel = await _controller!.getMaxZoomLevel();

    if (mounted) {
      setState(() {});
    }
  }

  // カメラの初期化 (2回目以降)
  Future<void> initializeCamera2({
    required int? useCameraIndex,
    required bool isFlashOn,
  }) async {
    final cameras = await availableCameras();

    // 超広角カメラを探す (built-in_video:5 を指定)
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == CameraLensDirection.back) {
        if (cameras[i].name.contains('built-in_video:5')) {
          wideOutCameraIndex = i;
        } else if (cameras[i].name.contains('built-in_video:0')) {
          normalOutCameraIndex = i;
        }
      } else if (cameras[i].lensDirection == CameraLensDirection.front) {
        inCameraIndex = i;
      }
    }

    // debugPrint('🔵 超広角カメラは、$wideOutCameraIndex');
    // debugPrint('🔵 通常カメラは、$normalOutCameraIndex');
    // debugPrint('🔵 インカメラは、$inCameraIndex');


    _controller = CameraController(
      cameras[useCameraIndex ?? 0],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();

    await _initializeControllerFuture;
    await _controller!.setFlashMode((isFlashOn) ? FlashMode.always : FlashMode.off);    // フラッシュを設定
    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);            // カメラの向きを縦に固定

    // ズームレベルの範囲を取得
    _minZoomLevel = await _controller!.getMinZoomLevel();
    _maxZoomLevel = await _controller!.getMaxZoomLevel();

    if (mounted) {
      setState(() {});
    }
  }

  // 初期読み込み
  Future<void> firstLoad() async {
    final leftHandedModePreference = widget.leftHandedMode;
    final keepIsCameraAllowed = await functionCheckCameraPermission();
    final keepIsMicAllowed = await functionCheckMicPermission();

    setState(() {
      leftHandedMode = leftHandedModePreference;   // 設定値読み込み
      isCameraAllowed = keepIsCameraAllowed;       // カメラ権限確認
      isMicAllowed = keepIsMicAllowed;             // マイク権限確認
      isFirstLoaded = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 撮影用関数
  Future<void> _takePicture({required int nowCameraIndex, required bool isFlashOn}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));  // 0.1秒待機
      setState(() {
        isTaking = true;
      });
      // await _initializeControllerFuture;

      // ------------------- メイン画像を撮影 -------------------
      final mainImage = await _controller!.takePicture();
      mainImagePath = mainImage.path;
      if (!mounted) return;
      // -----------------------------------------------------

      // -------------------- カメラ切り替え --------------------
      if (nowCameraIndex == normalOutCameraIndex || nowCameraIndex == wideOutCameraIndex) {
        _cameraIndex = inCameraIndex ?? 1;
      } else {
        _cameraIndex = normalOutCameraIndex ?? 0;
      }
      // -----------------------------------------------------

      // -------------------- サブ画像を撮影 --------------------
      await initializeCamera2(
        useCameraIndex: _cameraIndex,
        isFlashOn: isFlashOn
      );
      await _initializeControllerFuture; // 初期化が完了するまで待機
      await Future.delayed(const Duration(milliseconds: 550));  // 0.55秒待機
      final subImage = await _controller!.takePicture();
      subImagePath = subImage.path;

      await Future.delayed(const Duration(milliseconds: 1600));  // 1.6秒待機

      // 両方のカメラで撮影完了後にConfirmPageに遷移
      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ConfirmPage(
              leftHandedMode: leftHandedMode,
              mainImagePath: mainImagePath ?? '',
              subImagePath: subImagePath ?? ''
            ),
            transitionDuration: Duration.zero, // アニメーション時間を0にする
            reverseTransitionDuration: Duration.zero, // 戻るときのアニメーションも0にする
            fullscreenDialog: true
          ),
        );
      }
      // -----------------------------------------------------

      // ---------------- カメラの内/外を元に戻す ----------------
      _cameraIndex = nowCameraIndex;
      await initializeCamera2(
        useCameraIndex: _cameraIndex,
        isFlashOn: isFlashOn
      );
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
  Future switchCamera({required int? nowCameraIndex, required bool isFlashOn}) async {
    HapticFeedback.lightImpact();     // 触覚フィードバック

    if (nowCameraIndex == normalOutCameraIndex || nowCameraIndex == wideOutCameraIndex) {
      setState(() {
        _cameraIndex = inCameraIndex ?? 1;
      });
    } else {
      setState(() {
        _cameraIndex = normalOutCameraIndex ?? 0;
      });
    }
    initializeCamera2(
      useCameraIndex: _cameraIndex,
      isFlashOn: isFlashOn
    );

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
  Future switchCameraMagnification({
    required int? nowCameraIndex,
    required bool isFlashOn
  }) async {
    HapticFeedback.lightImpact();     // 触覚フィードバック

    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {isSwitchCameraRate = true;});

    if (wideOutCameraIndex != null) {
      setState(() {isChangingCamera = true;});
    }

    if (nowCameraIndex != inCameraIndex) {
      if (wideOutCameraIndex != null && normalOutCameraIndex != null) {
        if (nowCameraIndex == wideOutCameraIndex) {
          setState(() {
            _cameraIndex = normalOutCameraIndex!;
            setState(() {_currentZoomLevel = 1.0;});
          });
        } else if (nowCameraIndex == normalOutCameraIndex) {
          setState(() {
            _cameraIndex = wideOutCameraIndex!;
            setState(() {_currentZoomLevel = 0.5;});
          });
        }
      }
    }

    if (wideOutCameraIndex != null) {
      await initializeCamera2(
        useCameraIndex: _cameraIndex,
        isFlashOn: isFlashOn
      );
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {isChangingCamera = false;});

    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {isSwitchCameraRate = false;});
  }

  // ズームレベルを変更する関数
  Future<void> _setZoomLevel(double zoomLevel, {required int? nowCameraIndex}) async {
    if (_cameraIndex == normalOutCameraIndex) {
      if (zoomLevel < _minZoomLevel) {
        zoomLevel = _minZoomLevel;
      } else if (zoomLevel > _maxZoomLevel) {
        zoomLevel = _maxZoomLevel;
      } else {
        await _controller!.setZoomLevel(zoomLevel);
        setState(() {
          _currentZoomLevel = zoomLevel;
        });
      }
    } else if (_cameraIndex == wideOutCameraIndex) {
      if (zoomLevel < _minZoomLevel) {
        zoomLevel = _minZoomLevel;
      } else if (zoomLevel > 1.7254) {
        zoomLevel = 1.7254;
      } else {
        await _controller!.setZoomLevel(zoomLevel);
        setState(() {
          _currentZoomLevel = zoomLevel;
        });
      }
    }
  }
  /*
  Future<void> _setZoomLevel(double zoomLevel) async {
    if (zoomLevel < _minZoomLevel) {
      zoomLevel = _minZoomLevel;
    } else if (zoomLevel > _maxZoomLevel) {
      zoomLevel = _maxZoomLevel;
    }
    await _controller!.setZoomLevel(zoomLevel);
    setState(() {
      _currentZoomLevel = zoomLevel;
    });
  }
  */





  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;     // 画面の高さを取得
    bool isCompactDisplay = screenHeight < 743;       // 画面の高さが 743px未満 だったらコンパクト表示


    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CompCommonAppbar(
          isCompactDisplay: isCompactDisplay,
          leftHandedMode: leftHandedMode
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            bool isPrepaired = snapshot.connectionState == ConnectionState.done;

            return CompCommonBodyColumn(
              isCompactDisplay: isCompactDisplay,
              needBottomPadding: false,
              // ================================================== カメラ画像部分 ===================================================
              centerElement:
                (!isFirstLoaded)
                  ? AspectRatio(
                    aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                    child: CompLoading(message: AppLocalizations.of(context)!.prepairing)
                  )
                  :(!isCameraAllowed || !isMicAllowed)     // カメラとマイクの権限が許可されていないかどうか
                    // カメラまたはマイクの権限が許可されていない場合の表示
                    ? AspectRatio(
                        aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                        child: CompNotAllowed(
                          isCameraAllowed: isCameraAllowed,
                          isMicAllowed: isMicAllowed
                        ),
                    )
                    : (!isPrepaired)
                      // カメラ切り替え中の表示
                      ? AspectRatio(
                        aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                        child: CompLoading(message: AppLocalizations.of(context)!.prepairing)
                      )
                      // 撮影中の表示
                      :(isTaking)
                        ? AspectRatio(
                          aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                          child: CompLoading(
                            message: AppLocalizations.of(context)!.taking,
                            subMessage: AppLocalizations.of(context)!.differentFromBeReal
                          ),
                        )
                        : Stack(
                          children: [
                            // ------------------------- カメラ画像のContainer -------------------------
                            GestureDetector(
                              onScaleStart: (details) {
                                _baseZoom = _currentZoomLevel;
                              },
                              onScaleUpdate: (details) {
                                _setZoomLevel(
                                  _baseZoom * details.scale,
                                  nowCameraIndex: _cameraIndex
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: CameraPreview(_controller!),
                                ),
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
                                    // ? CompDisplaySwitch('フラッシュが ${(isFlashOn) ? 'オン' : 'オフ'} になりました')
                                    ? CompDisplaySwitch((isFlashOn)
                                      ? AppLocalizations.of(context)!.flashHasTurnedOn
                                      : AppLocalizations.of(context)!.flashHasTurnedOff
                                    )
                                    : const SizedBox.shrink(),
                                  // カメラ
                                  (isSwitchCamera)
                                    ? CompDisplaySwitch((_cameraIndex==0)
                                      ? AppLocalizations.of(context)!.cameraHasSwitchedToOuter
                                      : AppLocalizations.of(context)!.cameraHasSwitchedToInner
                                    )
                                    : const SizedBox.shrink(),
                                  // 倍率
                                  (isSwitchCameraRate)
                                    ? CompDisplaySwitch((wideOutCameraIndex != null)
                                      ? AppLocalizations.of(context)!.changedCameraMagnification
                                      : AppLocalizations.of(context)!.cannotCameraMagnification
                                    )
                                    : const SizedBox.shrink(),

                                  (isSwitchFlash || isSwitchCamera || isSwitchCameraRate)
                                    ? const SizedBox(height: 20)
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
                                        (_cameraIndex != inCameraIndex)
                                          ? CompCameraMagnificationIcon(
                                            isChangingCamera: isChangingCamera,
                                            isNormalCamera: _cameraIndex==normalOutCameraIndex,
                                            cameraRate: _currentZoomLevel,
                                            onPressed: (bool recvBool) {
                                              switchCameraMagnification(
                                                nowCameraIndex: _cameraIndex,
                                                isFlashOn: isFlashOn
                                              );
                                            },
                                          )
                                          : const SizedBox.shrink(),
                                        // - - - - - - - - - - - - - - - - -
                                        // - - イン/アウトカメラ切替ボタン - - -
                                        CompCameraIcon(
                                          cameraIndex: _cameraIndex,
                                          onPressed: (int recvInt) {
                                            switchCamera(
                                              nowCameraIndex: _cameraIndex,
                                              isFlashOn: isFlashOn
                                            );
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
                                        (_cameraIndex != inCameraIndex)
                                          ? CompCameraMagnificationIcon(
                                            isChangingCamera: isChangingCamera,
                                            isNormalCamera: _cameraIndex==normalOutCameraIndex,
                                            cameraRate: _currentZoomLevel,
                                            onPressed: (bool recvBool) {
                                              switchCameraMagnification(
                                                nowCameraIndex: _cameraIndex,
                                                isFlashOn: isFlashOn
                                              );
                                            },
                                          )
                                          : const SizedBox.shrink(),
                                        // - - - - - - - - - - - - - - - - -
                                        // - - イン/アウトカメラ切替ボタン - - -
                                        CompCameraIcon(
                                          cameraIndex: _cameraIndex,
                                          onPressed: (int recvInt) {
                                            switchCamera(
                                              nowCameraIndex: _cameraIndex,
                                              isFlashOn: isFlashOn
                                            );
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
                    ),
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
                        ? () => _takePicture(nowCameraIndex: _cameraIndex, isFlashOn: isFlashOn)     // 準備中かつ撮影中でなければ写真を撮る関数を呼び出せる
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

