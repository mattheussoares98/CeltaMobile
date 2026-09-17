import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerEmptyErrors extends ConsumerWidget {
  const SynchronizerEmptyErrors({super.key, this.detailsProvider});
  final SynchronizerDetailsStateControllerProvider? detailsProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const .all(Sizes.p12),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const PlatformIcon(
              cupertinoIcon: CupertinoIcons.checkmark_seal,
              materialIcon: Icons.check_circle_outline,
              size: 60,
            ),
            gapH16,
            BaseText.headline(
              'Nenhum erro foi encontrado'.hardcoded,
              color: Colors.green,
            ),
            if (detailsProvider != null) ...[
              gapH32,
              PrimaryButton(
                text: 'Recarregar'.hardcoded,
                onPressed: () => ref.invalidate(detailsProvider!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
