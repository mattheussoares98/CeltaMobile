import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/buyer/buyer.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';

class BuyersDropdown extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  const BuyersDropdown({
    super.key,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedBuyer = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        code.toString(),
      ).select((s) => s.value?.Buyer),
    );

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(buyersStateControllerProvider),
      tryAgain: () => ref.invalidate(buyersStateControllerProvider),
      data: (buyers) {
        return SliverToBoxAdapter(
          child: Stack(
            children: [
              if (selectedBuyer?.Name != null)
                Positioned(
                  top: 3,
                  left: 5,
                  child: Text(
                    'Comprador'.hardcoded,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              DefaultDropDown<BuyerEntity?>(
                onChanged: (buyer) {
                  ref
                      .read(
                        completeBuyQuotationsStateControllerProvider(
                          enterpriseCode,
                          code.toString(),
                        ).notifier,
                      )
                      .updateValues(Buyer: buyer);
                },
                hint: Text(selectedBuyer?.Name ?? 'Comprador'.hardcoded),
                selectedItem: selectedBuyer,
                label: selectedBuyer?.Name ?? 'Comprador'.hardcoded,
                items: buyers
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey('buyer_item_${e.Code}'),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
