import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class ReloadButton extends ConsumerWidget {
  final int saleRequestId;
  const ReloadButton({super.key, required this.saleRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasError = ref.watch(
      saleRequestDetailsStateControllerProvider(
        saleRequestId,
      ).select((s) => s.hasError),
    );
    if (hasError) {
      return SliverToBoxAdapter(
        child: PrimaryTextButton(
          text:
              'Não foi possível carregar o pedido. Tentar novamente'.hardcoded,
          onPressed: () => ref.invalidate(
            saleRequestDetailsStateControllerProvider(saleRequestId),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
