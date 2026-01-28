import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/buyer/buyer.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class BuyersDropdown extends ConsumerWidget {
  final bool enabled;
  const BuyersDropdown({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueSliverWidget(
      value: ref.watch(buyersStateControllerProvider),
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
              Consumer(
                builder: (_, ref, _) {
                  final selectedBuyer = ref.watch(
                    pendingBuyRequestStateControllerProvider.select(
                      (s) => s.value?.selectedBuyer,
                    ),
                  );

                  return DefaultSimpleDropDown<BuyerEntity?>(
                    onChanged: enabled
                        ? (buyer) {
                            ref
                                .read(
                                  pendingBuyRequestStateControllerProvider
                                      .notifier,
                                )
                                .updatePending(selectedBuyer: buyer);
                          }
                        : null,
                    items: buyers
                        .map(
                          (e) => DropdownMenuItem(
                            key: ValueKey(e.Code),
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
                    value: selectedBuyer,
                    hint: 'Selecione'.hardcoded,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
