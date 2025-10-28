import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../pages.dart';

class ClearCartButton extends ConsumerWidget {
  final InsertProductsPage insertProductsPage;
  const ClearCartButton({super.key, required this.insertProductsPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: PrimaryTextButton(
        text: 'Limpar carrinho'.hardcoded,
        color: Colors.red,
        icon: Icon(
          isIOS ? CupertinoIcons.delete : Icons.delete,
          color: Colors.red,
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
                    cartProductsStateControllerProvider(
                      DraftKey(
                        requestTypeCode: insertProductsPage.requestTypeCode,
                        enterpriseOrigin:
                            insertProductsPage.enterpriseOriginCode,
                        enterpriseDestinyCode:
                            insertProductsPage.enterpriseDestinyCode,
                      ),
                    ).notifier,
                  )
                  .clearLot();
            },
          );
        },
      ),
    );
  }
}
