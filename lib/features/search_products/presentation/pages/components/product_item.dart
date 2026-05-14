import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../exceptions/exceptions.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int enterpriseCode;
  const ProductItem({
    super.key,
    required this.product,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.priceConference,
      notClickableBottom: Column(
        children: [
          Consumer(
            builder: (_, ref, _) {
              final isLoading = ref.watch(
                sendToPrintControllerProvider(
                  product.ProductPackingCode!,
                ).select((state) => state.isLoading),
              );

              return PrimaryTextButton(
                text: product.PendantPrintLabel!
                    ? 'Desmarcar para impressão'.hardcoded
                    : 'Marcar para impressão'.hardcoded,
                icon: PlatformIcon(
                  cupertinoIcon: product.PendantPrintLabel!
                      ? CupertinoIcons.printer_fill
                      : CupertinoIcons.printer,
                  materialIcon: product.PendantPrintLabel!
                      ? Icons.print_disabled
                      : Icons.print,
                  color: isLoading
                      ? theme.disabledColor
                      : product.PendantPrintLabel!
                      ? Colors.red
                      : null,
                ),
                color: product.PendantPrintLabel! ? Colors.red : null,
                isLoading: isLoading,
                onPressed: () async {
                  await ref
                      .read(
                        sendToPrintControllerProvider(
                          product.ProductPackingCode!,
                        ).notifier,
                      )
                      .send(
                        newValue: !product.PendantPrintLabel!,
                        enterpriseCode: enterpriseCode,
                        routine: BsRoutine.priceConference,
                      );
                },
              );
            },
          ),
          Consumer(
            builder: (_, ref, _) {
              final error = ref.watch(
                sendToPrintControllerProvider(
                  product.ProductPackingCode!,
                ).select((state) => state.error),
              );

              if (error == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                child: Text(
                  'Erro ao atualizar impressão: ${parseErrorMessage(error)}'
                      .hardcoded,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
