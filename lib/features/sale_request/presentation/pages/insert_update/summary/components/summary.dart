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

    //TODO use ExpansionTile instead. Create a default one
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.p8),
        color: Colors.amber.withValues(alpha: .25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSubTitle(
            title: 'Total bruto'.hardcoded,
            subTitle: saleRequest.totalProductsBrut,
            subTitleIsPrice: true,
          ),
          ManageDiscountOrIncrement(
            valueType: saleRequest.increment,
            allowUpdate: saleRequest.requestType?.allowUseIncrement == true,
            title: 'Acréscimo no pedido'.hardcoded,
            onUpdate: notifier.updateIncrement,
            onRemove: notifier.removeIncrement,
            notAllowedMessage: 'Não permitido'.hardcoded,
          ),
          ManageDiscountOrIncrement(
            valueType: saleRequest.discounts?.firstOrNull?.discount,
            allowUpdate: saleRequest.requestType?.allowUseDiscount == true,
            title: 'Desconto no pedido'.hardcoded,
            onUpdate: notifier.updateDiscount,
            onRemove: notifier.removeDiscount,
            notAllowedMessage: 'Não permitido'.hardcoded,
          ),
          //TODO show all discounts
          ManageDiscountOrIncrement(
            valueType: saleRequest.deliveryTax?.deliveryTax,
            allowUpdate: saleRequest.requestType?.allowUseDeliveryTax == true,
            title: 'Entrega do pedido'.hardcoded,
            onUpdate: notifier.updateDeliveryTax,
            onRemove: notifier.removeDeliveryTax,
            notAllowedMessage: 'Não permitido'.hardcoded,
          ),
          TitleAndSubTitle(
            title: 'Acréscimo nos produtos'.hardcoded,
            subTitle: saleRequest.productsIncrement,
            subTitleIsPrice: true,
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.amber,
            ),
          ),
          TitleAndSubTitle(
            title: 'Desconto nos produtos'.hardcoded,
            subTitle: saleRequest.productsDiscount,
            subTitleIsPrice: true,
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),

          TitleAndSubTitle(
            title: 'Acréscimo financeiro'.hardcoded,
            subTitle: saleRequest.financialIncrementValue,
            subTitleIsPrice: true,
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.amber,
            ),
          ),
          TitleAndSubTitle(
            title: 'Desconto financeiro'.hardcoded,
            subTitle: saleRequest.financialDiscountValue,
            subTitleIsPrice: true,
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),
          TitleAndSubTitle(
            title: 'Total líquido'.hardcoded,
            subTitle: saleRequest.currentSaleRequestLiquid,
            subTitleIsPrice: true,
          ),
        ],
      ),
    );
  }
}
