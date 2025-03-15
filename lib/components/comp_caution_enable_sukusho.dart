import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class CautionEnableSukusho extends StatelessWidget {
  const CautionEnableSukusho({
    super.key,
    this.customBottomPadding = 0
  });

  final double customBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: customBottomPadding),
      child: Text(
        AppLocalizations.of(context)!.cannotSaveImagesAppBar,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}