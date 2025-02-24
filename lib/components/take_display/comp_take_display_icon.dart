import 'package:flutter/material.dart';
import 'package:berehearsal/components/take_display/comp_take_display_icon.dart';


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
    required this.onPressed
  });

  final void Function(bool) onPressed;

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
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.6 * 255).round()),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: const Center(
          child: Text(
            '1x',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        )
      ),
    );
  }
}