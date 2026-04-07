import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class ReloadButton extends ConsumerWidget {
  final int saleRequestId;
  final int customerCode;
  final int enterpriseCode;
  const ReloadButton({
    super.key,
    required this.saleRequestId,
    required this.customerCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = saleRequestDetailsStateControllerProvider(
      saleRequestCode: saleRequestId,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
    );

    final (hasError, isLoading) = ref.watch(
      provider.select((s) => (s.hasError, s.isLoading)),
    );
    if (hasError) {
      return PrimaryTextButton(
        text: 'Não foi possível carregar o pedido. Tentar novamente'.hardcoded,
        onPressed: () => ref.invalidate(provider),
        isLoading: isLoading,
      );
    }
    return const SizedBox.shrink();
  }
}
