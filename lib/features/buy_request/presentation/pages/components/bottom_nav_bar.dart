import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingValue = ref
        .watch(pendingBuyRequestStateControllerProvider)
        .value;

    final currentIndex = ref.watch(
      uiStateControllerProvider.select((s) => s.value?.currentPageIndex ?? 0),
    );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        bool buyerIsSelected = pendingValue?.selectedBuyer != null;
        bool requestTypeIsSelected = pendingValue?.selectedRequestType != null;
        bool supplierIsSelected = pendingValue?.selectedSupplier != null;

        if (index == 1 || index == 2) {
          if (!buyerIsSelected) {
            showSnackBarMessage(
              context,
              'Selecione um comprador'.hardcoded,
              backgroundColor: Colors.red,
            );
            return;
          } else if (!requestTypeIsSelected) {
            showSnackBarMessage(
              context,
              'Selecione um modelo de pedido'.hardcoded,
              backgroundColor: Colors.red,
            );
            return;
          } else if (!supplierIsSelected) {
            showSnackBarMessage(
              context,
              'Selecione um fornecedor'.hardcoded,
              backgroundColor: Colors.red,
            );
            return;
          }
        }

        bool enterprisesAreValid =
            pendingValue?.selectedEnterprises != null &&
            pendingValue!.selectedEnterprises!.isNotEmpty;
        if (index == 2 && !enterprisesAreValid) {
          showSnackBarMessage(
            context,
            'Selecione pelo menos uma empresa'.hardcoded,
            backgroundColor: Colors.red,
          );
          return;
        }

        ref.read(uiStateControllerProvider.notifier).updatePageIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Identificação'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                pendingValue?.selectedBuyer != null &&
                pendingValue?.selectedRequestType != null &&
                pendingValue?.selectedSupplier != null,
            materialIcon: Icons.info,
            cupertinoIcon: CupertinoIcons.info,
            isSelected: currentIndex == 0,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Empresas'.hardcoded,
          icon: QuantityBadge(
            quantity: pendingValue?.selectedEnterprises?.length,
            materialIcon: Icons.business,
            cupertinoIcon: CupertinoIcons.building_2_fill,
            isSelected: currentIndex == 1,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          icon: QuantityBadge(
            quantity: pendingValue?.products?.length,
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            isSelected: currentIndex == 2,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Confirmação'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                pendingValue?.selectedBuyer != null &&
                pendingValue?.selectedRequestType != null &&
                pendingValue?.selectedSupplier != null &&
                pendingValue?.products?.isNotEmpty == true,
            materialIcon: Icons.check_box_outlined,
            cupertinoIcon: CupertinoIcons.checkmark_square,
            isSelected: currentIndex == 3,
          ),
        ),
      ],
    );
  }
}
