import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyRequestDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int buyRequestCode;
  const BuyRequestDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyRequestCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyRequestDetailsStateControllerProvider(buyRequestCode);
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'Detalhes'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (buyRequest) {
          return Column(
            children: [SearchedBuyRequestItem(buyRequest: buyRequest)],
          );
        },
      ),
    );
  }
}
