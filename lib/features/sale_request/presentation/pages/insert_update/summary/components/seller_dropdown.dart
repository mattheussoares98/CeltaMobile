import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerDropdown extends ConsumerWidget {
  const SellerDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(sellersStateControllerProvider),
      tryAgain: () => ref.invalidate(sellersStateControllerProvider),
      data: (sellers) {
        if (sellers.isEmpty) return const SizedBox.shrink();

        final selectedSellerCode = ref.watch(
          insertUpdateStateControllerProvider.select(
            (s) => s.value?.seller?.code,
          ),
        );

        final selectedSeller = sellers
            .where((s) => s.Id == selectedSellerCode)
            .firstOrNull;

        return Row(
          children: [
            Expanded(
              child: DefaultDropDown<EcSellerEntity>(
                showLabelAtTopLeft: true,
                label: 'Vendedor'.hardcoded,
                selectedItem: selectedSeller,
                items: sellers.map((seller) {
                  return DropdownMenuItem(
                    value: seller,
                    child: Center(child: Text(seller.Name)),
                  );
                }).toList(),
                onChanged: (seller) {
                  ref
                      .read(insertUpdateStateControllerProvider.notifier)
                      .changeSeller(seller);
                },
              ),
            ),
            if (selectedSeller != null) ...[
              gapW8,
              IconButton(
                icon: const PlatformIcon(
                  materialIcon: Icons.close,
                  cupertinoIcon: CupertinoIcons.clear,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref
                      .read(insertUpdateStateControllerProvider.notifier)
                      .changeSeller(null);
                },
                tooltip: 'Remover Vendedor'.hardcoded,
              ),
            ],
          ],
        );
      },
    );
  }
}
