import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerSendDataItem extends ConsumerWidget {
  const SynchronizerSendDataItem({super.key, required this.item});
  final EcSendDataSynchronizerErrorDetailEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProvider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.sendData,
    );

    void onTap(int code) {
      ref.read(selectedProvider.notifier).select(code);
    }

    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () => onTap(item.internalCode),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TitleAndSubTitle(
                      title: 'Site'.hardcoded,
                      subTitle: item.commerceSite,
                    ),
                  ),
                  gapW4,
                  Consumer(
                    builder: (_, ref, _) {
                      final isSelected = ref.watch(
                        selectedProvider.select(
                          (s) => s.contains(item.internalCode),
                        ),
                      );
                      return BaseCheckBox(
                        name: 'Selecionar'.hardcoded,
                        enabled: isSelected,
                        onChanged: (_) => onTap(item.internalCode),
                        width: Sizes.p20,
                        height: Sizes.p20,
                      );
                    },
                  ),
                ],
              ),
              TitleAndSubTitle(
                title: 'Descrição'.hardcoded,
                subTitle: item.description,
              ),
              if (item.siteCode.isNotEmpty)
                TitleAndSubTitle(
                  title: 'ID Site'.hardcoded,
                  subTitle: item.siteCode,
                ),
              if (item.sendDate != null)
                TitleAndSubTitle(
                  title: 'Data envio'.hardcoded,
                  subTitle: item.sendDate?.formatDate(.ddMMyyyyHHmm),
                ),
              if (item.error.isNotEmpty)
                BaseText.error(item.error, textAlign: .start),
            ],
          ),
        ),
      ),
    );
  }
}
