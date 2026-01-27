import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class Covenants extends ConsumerWidget {
  final CustomerItem customerItem;
  final int enterpriseCode;
  const Covenants({
    super.key,
    required this.customerItem,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCovenant = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.covenant),
    );

    void onTapCovenant(CustomerCovenantEntity covenant) {
      ref
          .read(
            pendingSaleRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .changeCovenant(covenant);
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: customerItem.customer.CustomerCovenants!.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(height: 0),
                Text(
                  'Convênios'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ],
            );
          }
          final covenant = customerItem.customer.CustomerCovenants![index - 1];
          return _CovenantItem(
            key: ValueKey(covenant.covenant?.Code),
            covenant: covenant,
            selectedCovenant: selectedCovenant,
            onTapCovenant: () => onTapCovenant(covenant),
          );
        },
      ),
    );
  }
}

class _CovenantItem extends StatelessWidget {
  final CustomerCovenantEntity covenant;
  final CustomerCovenantEntity? selectedCovenant;
  final VoidCallback onTapCovenant;
  const _CovenantItem({
    super.key,
    required this.covenant,
    required this.selectedCovenant,
    required this.onTapCovenant,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: Sizes.p8),
        child: InkWell(
          onTap: onTapCovenant,
          child: RadioGroup<CustomerCovenantEntity>(
            groupValue: selectedCovenant,
            onChanged: (_) => onTapCovenant(),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TitleAndSubTitle(
                          title: null,
                          subTitle: covenant.covenant?.Name,
                        ),
                        if (covenant.LimitOfPurchase != null)
                          TitleAndSubTitle(
                            title: 'Limite'.hardcoded,
                            subTitle: covenant.LimitOfPurchase,
                            subTitleIsPrice: true,
                          ),
                      ],
                    ),
                  ),
                  Radio(value: covenant, toggleable: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
