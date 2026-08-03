import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleRequestWithErrorsItems extends ConsumerWidget {
  const SaleRequestWithErrorsItems({super.key, required this.items});
  final List<BSFSaleRequestWithErrorSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.saleRequestWithError,
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
                          title: 'Empresa'.hardcoded,
                          subTitle: item.enterprisePersonalizedCode,
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
                    title: 'Última leitura'.hardcoded,
                    subTitle: item.creationDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: 'Criação do pedido'.hardcoded,
                    subTitle: item.cadasterDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  for (var i = 0; i < item.details.length; i++)
                    Column(
                      children: [
                        if (i > 0 && i < item.details.length) const Divider(),
                        BaseText.title(
                          item.details[i],
                          color: Colors.red,
                          textAlign: .start,
                        ),
                      ],
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
