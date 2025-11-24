import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class NamePluAndDeleteButton extends ConsumerWidget {
  final CartProductEntity cartProduct;
  const NamePluAndDeleteButton({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(
                title: cartProduct.product!.Name,
                subTitle:
                    " (${cartProduct.product!.PackingQuantity!.formattedPacking()})",
                titleStyle: theme.textTheme.titleMedium,
                subTitleStyle: theme.textTheme.bodyMedium,
              ),
              TitleAndSubTitle(
                title: 'PLU'.hardcoded,
                subTitle: cartProduct.product!.PLU,
                titleStyle: theme.textTheme.titleMedium,
                subTitleStyle: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                showAlertDialog(
                  context: context,
                  title: 'Remover produto?'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  onOkPressed: () {
                    ref
                        .read(
                          pendingSaleRequestStateControllerProvider.notifier,
                        )
                        .removeProduct(cartProduct);
                  },
                );
              },
              icon: Icon(
                isIOS ? CupertinoIcons.delete : Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
