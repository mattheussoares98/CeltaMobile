import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/buyer/buyer.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class BuyersDropdown extends ConsumerWidget {
  const BuyersDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyersState = ref.watch(buyersStateControllerProvider);
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    return AsyncValueSliverWidget(
      value: buyersState,
      tryAgain: () {
        ref.invalidate(buyersStateControllerProvider);
      },
      data: (buyers) {
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultSmallTitle(title: 'Comprador'.hardcoded),
              gapH4,
              DefaultSimpleDropDown<BuyerEntity?>(
                onChanged: (buyer) {
                  ref
                      .read(pendingBuyRequestStateControllerProvider.notifier)
                      .updatePending(
                        (pendingAsync.value ?? PendingBuyRequestEntity.empty())
                            .copyWith(selectedBuyer: buyer),
                      );
                },
                items: buyers
                    ?.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Center(child: Text(e.Name)),
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um comprador'.hardcoded;
                  }
                  return null;
                },
                value: pendingAsync.value?.selectedBuyer,
                hint: 'Selecione'.hardcoded,
                isLoading: buyersState.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
