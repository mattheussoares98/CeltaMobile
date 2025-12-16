import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/buyer/buyer.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class BuyersDropdown extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  final int enterpriseCode;
  final int code;
  const BuyersDropdown({
    super.key,
    required this.buyQuotation,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AsyncValueSliverWidget(
      value: ref.watch(buyersStateControllerProvider),
      tryAgain: () => ref.invalidate(buyersStateControllerProvider),
      data: (buyers) {
        return SliverToBoxAdapter(
          child: Stack(
            children: [
              if (buyQuotation.Buyer?.Name != null)
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
                hint: Text('Comprador'.hardcoded),
                selectedItem: buyQuotation.Buyer,
                label: 'Comprador'.hardcoded,
                items: buyers
                    .map(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
