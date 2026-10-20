import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_movement/presentation/pages/shallow/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowBuyMovementsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyMovementsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, 0),
      appBar: BaseAppBar(
        title: context.l10n.coreModulesBuyMovement,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p12),
            child: Consumer(
              builder: (_, ref, _) {
                final provider = shallowBuyMovementStateControllerProvider(
                  enterpriseCode,
                );
                return SelectDateRangeAndSearchButton(
                  maximumDaysDifference: const Duration(days: 90),
                  isLoading: ref.watch(
                    provider.select((state) => state.isLoading),
                  ),
                  onSearch: (initialDate, finalDate) =>
                      ref.read(provider.notifier).load(initialDate, finalDate),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (_, ref, _) {
                final provider = shallowBuyMovementStateControllerProvider(
                  enterpriseCode,
                );
                return AsyncValueWidget(
                  value: ref.watch(provider),
                  tryAgain: null,
                  data: (buyMovements) {
                    if (buyMovements?.isEmpty == true) {
                      return Center(
                        child: BaseText.error(context.l10n.noPurchasesFound),
                      );
                    }

                    return ShallowBuyMovementItems(
                      enterpriseCode: enterpriseCode,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
