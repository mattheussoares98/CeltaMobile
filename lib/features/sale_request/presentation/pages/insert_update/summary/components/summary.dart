import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Summary extends ConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(insertUpdateStateControllerProvider.notifier);
    final saleRequest = ref.watch(
      insertUpdateStateControllerProvider.select((s) => s.value),
    );

    if (saleRequest == null) return const SizedBox();

    return ExpansionTile(
      title: Center(
        child: Text(
          context.l10n.summary,
          style: context.theme.textTheme.titleMedium,
        ),
      ),
      backgroundColor: Colors.amber.withValues(alpha: .25),
      collapsedBackgroundColor: Colors.amber.withValues(alpha: .3),
      initiallyExpanded: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndSubTitle(
              title: context.l10n.grossTotal,
              subTitle: saleRequest.totalProductsBrut,
              subTitleIsPrice: true,
            ),
            ManageDiscountOrIncrement(
              valueTypes: [saleRequest.increment],
              allowUpdate: saleRequest.requestType?.allowUseIncrement == true,
              title: context.l10n.orderSurcharge,
              onUpdate: notifier.updateIncrement,
              onRemove: notifier.removeIncrement,
              notAllowedMessage: context.l10n.notAllowed,
              liquidValue: saleRequest.saleRequestIncrement,
            ),
            ManageDiscountOrIncrement(
              valueTypes:
                  saleRequest.discounts?.map((e) => e.discount).toList() ?? [],
              allowUpdate: saleRequest.requestType?.allowUseDiscount == true,
              title: context.l10n.orderDiscount,
              onUpdate: notifier.updateDiscount,
              onRemove: notifier.removeDiscount,
              notAllowedMessage: context.l10n.notAllowed,
              liquidValue: saleRequest.saleRequestDiscount,
            ),
            ManageDiscountOrIncrement(
              valueTypes: [saleRequest.deliveryTax?.deliveryTax],
              allowUpdate: saleRequest.requestType?.allowUseDeliveryTax == true,
              title: context.l10n.orderDelivery,
              onUpdate: notifier.updateDeliveryTax,
              onRemove: notifier.removeDeliveryTax,
              notAllowedMessage: context.l10n.notAllowed,
              liquidValue: saleRequest.saleRequestDeliveryTax,
            ),
            TitleAndSubTitle(
              title: context.l10n.totalSurcharges,
              subTitle: saleRequest.totalIncrement,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.amber,
              ),
            ),
            TitleAndSubTitle(
              title: context.l10n.totalDiscounts2,
              subTitle: saleRequest.totalDiscount,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
              ),
            ),
            TitleAndSubTitle(
              title: context.l10n.totalDeliveryFees,
              subTitle: saleRequest.totalDeliveryTax,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.blue,
              ),
            ),
            TitleAndSubTitle(
              title: context.l10n.netTotal,
              subTitle: saleRequest.currentSaleRequestLiquid,
              subTitleIsPrice: true,
            ),
          ],
        ),
      ],
    );
  }
}
