import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../controllers/controllers.dart';

class ConfirmOrRequestButton extends ConsumerWidget {
  final bool isRequest;
  final int enterpriseCode;
  const ConfirmOrRequestButton({
    super.key,
    required this.isRequest,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: isRequest ? 'Solicitar'.hardcoded : 'Confirmar'.hardcoded,
      onPressed: () async {
        showAlertDialog(
          context: context,
          title: isRequest ? 'Solicitar?'.hardcoded : 'Confirmar?'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          onOkPressed: () async {
            final items = await ref.read(
              lotStateControllerProvider(enterpriseCode).future,
            );

            ref
                .read(confirmAdjustStockControllerProvider.notifier)
                .confirm(
                  items
                      .map(
                        (e) => AdjustStockItemEntity(
                          EnterpriseCode: e.product.EnterpriseCode,
                          ProductCode: e.product.ProductCode,
                          ProductPackingCode: e.product.ProductPackingCode,
                          JustificationCode:
                              e.selectedJustification.CodigoInterno_JustMov,
                          StockTypeCode:
                              e.selectedOriginStock.CodigoInterno_TipoEstoque!,
                          StockTypeRecipientCode:
                              e.selectedDestinyStock.CodigoInterno_TipoEstoque,
                          IsPendingAdjust: isRequest,
                          Quantity: e.quantity,
                        ),
                      )
                      .toList(),
                );
          },
        );
      },
    );
  }
}
