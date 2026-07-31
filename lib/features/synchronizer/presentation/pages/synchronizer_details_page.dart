import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerDetailsPage extends ConsumerWidget {
  const SynchronizerDetailsPage({super.key, required this.errorKey});
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = synchronizerDetailsStateControllerProvider(errorKey);
    final errorQuantity = ref.watch(
      synchronizerCountStateControllerProvider.select(
        (s) => s.value?.firstWhereOrNull((e) => e.errorKey == errorKey)?.count,
      ),
    );

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        titleWidget: BaseRichText(
          maxLines: 2,
          texts: [
            if (errorQuantity != null) BaseText.error('($errorQuantity) '),
            BaseText.title(errorKey, maxLines: 2),
          ],
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return ResponsiveListFlow(
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              final item = data.items[index];
              return BaseText(item.toString());
            },
          );
        },
      ),
    );
  }
}
