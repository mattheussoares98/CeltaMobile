import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleRequestMarkedItems extends ConsumerWidget {
  const SaleRequestMarkedItems({super.key, required this.items});
  final List<EcSaleRequestMarkedSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.saleRequestMarked,
    );

    return ResponsiveListFlow(
      itemCount: items.length,
      padding: const EdgeInsets.all(Sizes.p8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: () => ref.read(provider.notifier).select(item.code),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TitleAndSubTitle(
                          title: 'Código'.hardcoded,
                          subTitle: item.personalizedCode,
                        ),
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final isSelected = ref.watch(
                            provider.select((s) => s.contains(item.code)),
                          );
                          return BaseCheckBox(
                            name: 'Selecionar pedido'.hardcoded,
                            enabled: isSelected,
                            onChanged: (_) =>
                                ref.read(provider.notifier).select(item.code),
                            width: Sizes.p20,
                            height: Sizes.p20,
                          );
                        },
                      ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: 'Cliente'.hardcoded,
                    subTitle: item.customer,
                  ),
                  TitleAndSubTitle(
                    title: 'Valor'.hardcoded,
                    subTitle: item.totalLiquid,
                  ),
                  Align(
                    alignment: .centerRight,
                    child: PrimaryTextButton(
                      text: 'Visualizar pedido'.hardcoded,
                      onPressed: () {
                        ref
                            .read(tryAccessModuleControllerProvider.notifier)
                            .tryAccess(
                              context: context,
                              route: Routes.saleRequestDetails,
                              enterpriseCode: item.enterpriseCode,
                              module: Modules.saleRequest,
                              pathParameters: {
                                'enterpriseCode': item.enterpriseCode
                                    .toString(),
                                'customerCode': item.customerCode.toString(),
                                'saleRequestId': item.code.toString(),
                              },
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
