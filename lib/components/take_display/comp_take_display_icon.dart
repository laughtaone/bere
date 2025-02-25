import 'package:flutter/material.dart';


// 大もとのコンポーネントコード
class CompTakeDisplayIcon extends StatelessWidget {
  const CompTakeDisplayIcon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.customPadding = const EdgeInsets.all(0)
  });

  final IconData icon;
  final void Function()? onPressed;
  final EdgeInsetsGeometry customPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white.withAlpha((0.85 * 255).round()),
          size: 27,
        ),
        onPressed: onPressed,
      ),
    );
  }
}


// フラッシュボタン
class CompFlashIcon extends StatefulWidget {
  const CompFlashIcon({super.key,
    required this.isFlashOn,
    required this.onPressed
  });

  final bool isFlashOn;
  final void Function(bool) onPressed;

  @override
  CompFlashIconState createState() => CompFlashIconState();
}
class CompFlashIconState extends State<CompFlashIcon> {

  @override
  Widget build(BuildContext context) {
    return CompTakeDisplayIcon(
      icon: (widget.isFlashOn) ? Icons.flash_on_rounded : Icons.flash_off_rounded,
      customPadding: const EdgeInsets.only(left: 7),
      onPressed: () => widget.onPressed(widget.isFlashOn)
    );
  }
}


// カメラ内外ボタン
class CompCameraIcon extends StatefulWidget {
  const CompCameraIcon({super.key,
    required this.cameraIndex,
    required this.onPressed
  });

  final int cameraIndex;
  final void Function(int) onPressed;

  @override
  CompCameraIconState createState() => CompCameraIconState();
}
class CompCameraIconState extends State<CompCameraIcon> {
  @override
  Widget build(BuildContext context) {
    return CompTakeDisplayIcon(
      icon: Icons.cached_outlined,
      customPadding: const EdgeInsets.only(right: 7),
      onPressed: () => widget.onPressed(widget.cameraIndex)
    );
  }
}



// カメラ倍率調整ボタン
class CompCameraMagnificationIcon extends StatefulWidget {
  const CompCameraMagnificationIcon({super.key,
    required this.isChangingCamera,
    required this.isNormalCamera,
    required this.onPressed,
    required this.cameraRate
  });

  final bool isChangingCamera;
  final bool isNormalCamera;
  final void Function(bool) onPressed;
  final double cameraRate;

  @override
  CompCameraMagnificationIconState createState() => CompCameraMagnificationIconState();
}
class CompCameraMagnificationIconState extends State<CompCameraMagnificationIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10000))
      ),
      onPressed: () => widget.onPressed(true),
      icon: Container(
        width: 39,
        height: 39,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.5 * 255).round()),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Center(
          child: (widget.isChangingCamera)
          ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
          : Text(
            (widget.isNormalCamera)
              ? (widget.cameraRate >= 100)
                ? '${widget.cameraRate.toInt().toString()}x'
                  : (widget.cameraRate == widget.cameraRate.toInt())
                    ? '${widget.cameraRate.toInt().toString()}x'
                    : (double.parse(widget.cameraRate.toStringAsFixed(1)) == 1.0)
                      ? '1x'
                      : '${widget.cameraRate.toStringAsFixed(1)}x'
              : (((widget.cameraRate - 1) / 1.4508 + 0.5) < 0.51)
                ? '0.5x'
                : (((widget.cameraRate - 1) / 1.4508 + 0.5) >= 0.51 && double.parse(((widget.cameraRate - 1) / 1.4508 + 0.5).toStringAsFixed(1)) < 1)
                  ? '${((widget.cameraRate - 1) / 1.4508 + 0.5).toStringAsFixed(1)}x'
                  : (double.parse(((widget.cameraRate - 1) / 1.4508 + 0.5).toStringAsFixed(1)) > 1.0)
                    ? '0.99x'
                    : '0.99x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          )
        )
      ),
    );
  }
}