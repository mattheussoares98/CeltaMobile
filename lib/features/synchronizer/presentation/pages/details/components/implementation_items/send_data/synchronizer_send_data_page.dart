import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerSendDataPage extends ConsumerWidget {
  const SynchronizerSendDataPage({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<EcSendDataSynchronizerErrorDetailEntity> items;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SynchronizerEmptyErrors();

    final groupedErrors = groupBy(items, (e) => e.enterprisePersonalizedCode);
    final keys = groupedErrors.keys.toList();

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      body: ResponsiveListFlow(
        itemCount: keys.length,
        padding: const EdgeInsets.all(Sizes.p8),
        itemBuilder: (context, index) {
          final code = keys[index];
          final enterpriseErrors = groupedErrors[code] ?? [];
          final enterpriseCode =
              enterpriseErrors.firstOrNull?.enterpriseCode ?? 0;
          final enterprisePersonalizedCode =
              enterpriseErrors.firstOrNull?.enterprisePersonalizedCode ?? 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Consumer(
                builder: (context, ref, child) {
                  final enterpriseName = ref.watch(
                    enterprisesStateControllerProvider().select(
                      (s) => s.value
                          ?.firstWhereOrNull((e) => e.Code == enterpriseCode)
                          ?.name,
                    ),
                  );
                  return BaseRichText(
                    texts: [
                      BaseText.title(
                        (enterpriseName?.isNotEmpty ?? false)
                            ? '$enterprisePersonalizedCode - $enterpriseName'
                            : 'Empresa $enterprisePersonalizedCode'.hardcoded,
                      ),
                      BaseText.title(
                        ' (${enterpriseErrors.length})',
                        color: Colors.red,
                      ),
                    ],
                  );
                },
              ),
              children: enterpriseErrors.map((item) {
                return SynchronizerSendDataItem(item: item);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
