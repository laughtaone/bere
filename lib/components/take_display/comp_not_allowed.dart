import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



// カメラorマイクへのアクセスが未許可の場合の表示のコンポーネント
class CompNotAllowed extends StatefulWidget {
  const CompNotAllowed({super.key,
    required this.isCameraAllowed,
    required this.isMicAllowed
  });

  final bool isCameraAllowed;
  final bool isMicAllowed;

  @override
  CompNotAllowedState createState() => CompNotAllowedState();
}

class CompNotAllowedState extends State<CompNotAllowed> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_outlined, color: Colors.white, size: 35),
        const SizedBox(height: 10),
        Text(
          (!widget.isCameraAllowed && widget.isMicAllowed)
            ? AppLocalizations.of(context)!.notAllowedCamera
            : (widget.isCameraAllowed && !widget.isMicAllowed)
              ? AppLocalizations.of(context)!.notAllowedMic
              : AppLocalizations.of(context)!.notAllowedCameraAndMic,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 30),
        Text(
          AppLocalizations.of(context)!.descriptionNotAllowed,
          style: const TextStyle(color: Color(0xffc5c5c5), fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 50),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.2),
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10)
          ),
          onPressed: () async {
            await openAppSettings();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.settings_suggest_outlined, color: Colors.white, size: 27),
              const SizedBox(width: 5),
              Text(
                AppLocalizations.of(context)!.openSettings,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
              )
            ]
          )
        ),
      ]
    );
  }
}