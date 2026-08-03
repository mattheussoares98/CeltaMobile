import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleItems extends ConsumerWidget {
  const ScheduleItems({super.key, required this.items});
  final List<BSFScheduleSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.schedule,
    );

    return ResponsiveListFlow(
      itemCount: items.length,
      padding: const EdgeInsets.all(Sizes.p8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: item is RereadableSynchronizerErrorDetailEntity
                ? () => ref
                      .read(provider.notifier)
                      .select(1) //TODO fix
                : null,
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
                          subTitle: item.enterpriseName,
                        ),
                      ),
                      if (item is RereadableSynchronizerErrorDetailEntity)
                        Consumer(
                          builder: (_, ref, _) {
                            final isSelected = ref.watch(
                              provider.select((s) => s.contains(1)), //TODO fix
                            );
                            return BaseCheckBox(
                              name: 'Selecionar cupom'.hardcoded,
                              enabled: isSelected,
                              onChanged: (_) => ref
                                  .read(provider.notifier)
                                  .select(1), //TODO fix
                              width: Sizes.p20,
                              height: Sizes.p20,
                            );
                          },
                        ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: 'Data'.hardcoded,
                    subTitle: item.executionDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: null,
                    subTitle: item.description,
                    subTitleStyle: context.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                    copyableSubtitle: true,
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
