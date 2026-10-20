import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyDocumentsMessage extends ConsumerWidget {
  final VoidCallback onRefresh;
  const EmptyDocumentsMessage({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseText.error(
            context.l10n.noDocumentsAreUndergoingProductVerification,
            textAlign: TextAlign.center,
          ),
          gapH12,
          PrimaryTextButton(
            text: context.l10n.searchAgain,
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.refresh,
              materialIcon: Icons.refresh_rounded,
            ),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
