import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class ClearCartButton extends ConsumerWidget {
  final DraftKey draftKey;
  const ClearCartButton({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: Sizes.p16),
        child: PrimaryButton(
          text: 'Limpar carrinho'.hardcoded,
          backgroundColor: Colors.red,
          icon: Icon(
            isIOS ? CupertinoIcons.delete : Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            showAlertDialog(
              context: context,
              title: 'Limpar carrinho?'.hardcoded,
              defaultActionText: 'Limpar'.hardcoded,
              cancelActionText: 'Cancelar'.hardcoded,
              onOkPressed: () {
                ref
                    .read(
                      cartProductsStateControllerProvider(draftKey).notifier,
                    )
                    .clearLot();
              },
            );
          },
        ),
      ),
    );
  }
}
