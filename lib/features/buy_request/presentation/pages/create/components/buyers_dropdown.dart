import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/buyer/buyer.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyersDropdown extends ConsumerWidget {
  final bool enabled;
  final int enterpriseCode;
  const BuyersDropdown({
    super.key,
    this.enabled = true,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(buyersStateControllerProvider),
      tryAgain: () {
        ref.invalidate(buyersStateControllerProvider);
      },
      data: (buyers) {
        return _BuyersDropdown(
          enabled: enabled,
          buyers: buyers,
          enterpriseCode: enterpriseCode,
        );
      },
    );
  }
}

class _BuyersDropdown extends StatelessWidget {
  final bool enabled;
  final List<BuyerEntity> buyers;
  final int enterpriseCode;
  const _BuyersDropdown({
    required this.enabled,
    required this.buyers,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultSmallTitle(title: 'Comprador'.hardcoded),
        gapH4,
        Consumer(
          builder: (_, ref, _) {
            final selectedBuyer = ref.watch(
              pendingBuyRequestStateControllerProvider(
                enterpriseCode,
              ).select((s) => s.value?.selectedBuyer),
            );

            return BaseDropDown<BuyerEntity?>(
              onChanged: enabled
                  ? (buyer) {
                      ref
                          .read(
                            pendingBuyRequestStateControllerProvider(
                              enterpriseCode,
                            ).notifier,
                          )
                          .updatePending(selectedBuyer: buyer);
                    }
                  : null,
              items: buyers
                  .map(
                    (e) => DropdownMenuItem(
                      key: ValueKey(e.Code),
                      value: e,
                      child: BaseText(e.Name),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Selecione um comprador'.hardcoded;
                }
                return null;
              },
              selectedItem: selectedBuyer,
              label: 'Selecione'.hardcoded,
              isSimple: true,
            );
          },
        ),
      ],
    );
  }
}
