import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SynchronizerEmptyErrors extends StatelessWidget {
  const SynchronizerEmptyErrors({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const PlatformIcon(
            cupertinoIcon: CupertinoIcons.checkmark_seal,
            materialIcon: Icons.check_circle_outline,
            size: 60,
            //TODO check to create an animation when opening it
          ),
          gapH16,
          BaseText.headline(
            'Nenhum erro foi encontrado'.hardcoded,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
