import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadBleedingsItems extends ConsumerWidget {
  const ReadBleedingsItems({super.key, required this.items});
  final List<BSFReadBleedingSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.readBleeding,
    );
    return ResponsiveListFlow(
      padding: const EdgeInsets.all(Sizes.p8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final bleeding = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: () => ref.read(provider.notifier).select(bleeding.code),
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
                          subTitle: bleeding.enterprisePersonalizedCode,
                        ),
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final isSelected = ref.watch(
                            provider.select((s) => s.contains(bleeding.code)),
                          );
                          return BaseCheckBox(
                            name: 'Selecionar'.hardcoded,
                            enabled: isSelected,
                            onChanged: (_) => ref
                                .read(provider.notifier)
                                .select(bleeding.code),
                            width: Sizes.p20,
                            height: Sizes.p20,
                          );
                        },
                      ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: 'Caixa'.hardcoded,
                    subTitle: bleeding.cashierNumber,
                  ),
                  TitleAndSubTitle(
                    title: 'Data erro'.hardcoded,
                    subTitle: bleeding.creationDate.formatDate(.ddMMyyyyHHmm),
                  ),
                  TitleAndSubTitle(
                    title: 'Data sangria'.hardcoded,
                    subTitle: bleeding.movementDate.formatDate(.ddMMyyyyHHmm),
                  ),
                  TitleAndSubTitle(
                    title: 'Descrição'.hardcoded,
                    subTitle: null,
                    emptyMessage: bleeding.description,
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
