import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'confirm_page.dart';
import 'settings/settings_display.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';



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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[_cameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const CompTitleAppBar(),
            actions: const <Widget>[Setting()],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.expand_more_outlined)
            ),
          ),
          body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CautionEnableSukusho(),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ================================================= カメラ画像部分 始 =================================================
                        (snapshot.connectionState == ConnectionState.done)
                        ? Stack(
                          children: [
                            // ------------------------- カメラ画像のContainer -------------------------
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: AspectRatio(
                                  aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // - - - - - フラッシュボタン - - - - -
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: IconButton(
                                      icon: cameraImageFieldIconButton(
                                        Icons.electric_bolt_outlined,
                                        isActive: false
                                      ),
                                      onPressed: null,
                                    ),
                                  ),
                                  // - - - - - - - - - - - - - - - - -
                                  // - - - - - - 倍率ボタン - - - - - -
                                  IconButton(
                                    icon: cameraImageFieldIconButton(Icons.circle_outlined),
                                    onPressed: null,
                                  ),
                                  // - - - - - - - - - - - - - - - - -
                                  // - - イン/アウトカメラ切替ボタン - - -
                                  Padding(
                                    padding: const EdgeInsets.only(right: 7),
                                    child: IconButton(
                                      icon: cameraImageFieldIconButton(Icons.cached_outlined),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();     // 触覚フィードバック
                                        if (_cameraIndex == 0) {
                                          _cameraIndex = 1;
                                        } else {
                                          _cameraIndex = 0;
                                        }
                                        _initializeCamera();
                                      },
                                    ),
                                    // - - - - - - - - - - - - - - - - -
                                  ),
                                ],
                              ),
                            ),
                            // -----------------------------------------------------------------------
                          ],
                        )
                        // ------------------------- カメラ切り替え中の表示 -------------------------
                        : Container(
                          color: Colors.red,
                          child: AspectRatio(
                            aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                            child: Center(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            ),
                          ),
                        ),
                        // -----------------------------------------------------------------------
                        // ===================================================================================================================
                    
                        // ==================================================== 撮影ボタン ====================================================
                        IconButton(
                          onPressed: _takePicture, // 写真を撮る関数を呼び出し
                          icon: const Icon(Icons.radio_button_unchecked),
                          color: Colors.white,
                          iconSize: 100,
                        ),
                        // ===================================================================================================================
                      ]
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CautionEnableSukusho extends StatelessWidget {
  const CautionEnableSukusho({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 15), // 余白を設定
      child: const Text(
        '撮影した画像の保存・スクショは一切できません',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 設定ボタンの内容
class Setting extends StatelessWidget {
  const Setting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
            fullscreenDialog: true,
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}




// カメラ画像部分の上のIconButtonのスタイル
Icon cameraImageFieldIconButton(IconData receivedIcon, {bool isActive = true}) {
  return Icon(
    receivedIcon,
    color: Colors.white.withOpacity(isActive ? 0.85 : 0),
    size: 27,
  );
}
