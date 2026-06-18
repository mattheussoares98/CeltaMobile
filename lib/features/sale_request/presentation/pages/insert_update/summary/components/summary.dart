import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
          'Sumário'.hardcoded,
          style: context.theme.textTheme.titleMedium,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      backgroundColor: Colors.amber.withValues(alpha: .25),
      collapsedBackgroundColor: Colors.amber.withValues(alpha: .3),
      childrenPadding: const EdgeInsets.fromLTRB(
        Sizes.p8,
        0,
        Sizes.p8,
        Sizes.p8,
      ),
      iconColor: context.theme.primaryColorDark,
      collapsedIconColor: context.theme.primaryColor,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      initiallyExpanded: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(
              title: 'Total bruto'.hardcoded,
              subTitle: saleRequest.totalProductsBrut,
              subTitleIsPrice: true,
            ),
            ManageDiscountOrIncrement(
              valueTypes: [saleRequest.increment],
              allowUpdate: saleRequest.requestType?.allowUseIncrement == true,
              title: 'Acréscimo no pedido'.hardcoded,
              onUpdate: notifier.updateIncrement,
              onRemove: notifier.removeIncrement,
              notAllowedMessage: 'Não permitido'.hardcoded,
              liquidValue: saleRequest.saleRequestIncrement,
            ),
            ManageDiscountOrIncrement(
              valueTypes:
                  saleRequest.discounts?.map((e) => e.discount).toList() ?? [],
              allowUpdate: saleRequest.requestType?.allowUseDiscount == true,
              title: 'Desconto no pedido'.hardcoded,
              onUpdate: notifier.updateDiscount,
              onRemove: notifier.removeDiscount,
              notAllowedMessage: 'Não permitido'.hardcoded,
              liquidValue: saleRequest.saleRequestDiscount,
            ),
            ManageDiscountOrIncrement(
              valueTypes: [saleRequest.deliveryTax?.deliveryTax],
              allowUpdate: saleRequest.requestType?.allowUseDeliveryTax == true,
              title: 'Entrega do pedido'.hardcoded,
              onUpdate: notifier.updateDeliveryTax,
              onRemove: notifier.removeDeliveryTax,
              notAllowedMessage: 'Não permitido'.hardcoded,
              liquidValue: saleRequest.saleRequestDeliveryTax,
            ),
            TitleAndSubTitle(
              title: 'Total dos acréscimos'.hardcoded,
              subTitle: saleRequest.totalIncrement,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.amber,
              ),
            ),
            TitleAndSubTitle(
              title: 'Total dos descontos'.hardcoded,
              subTitle: saleRequest.totalDiscount,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
              ),
            ),
            TitleAndSubTitle(
              title: 'Total das taxas de entrega'.hardcoded,
              subTitle: saleRequest.totalDeliveryTax,
              subTitleIsPrice: true,
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.blue,
              ),
            ),
            TitleAndSubTitle(
              title: 'Total líquido'.hardcoded,
              subTitle: saleRequest.currentSaleRequestLiquid,
              subTitleIsPrice: true,
            ),
          ],
        ),
      ],
    );
  }
}
