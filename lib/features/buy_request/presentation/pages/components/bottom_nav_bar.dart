import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  final int enterpriseCode;
  const BottomNavBar({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      uiStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.currentPageIndex ?? 0),
    );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) async {
        final pendingValue = await ref.read(
          pendingBuyRequestStateControllerProvider(enterpriseCode).future,
        );

        bool buyerIsSelected = pendingValue.selectedBuyer != null;
        bool requestTypeIsSelected = pendingValue.selectedRequestType != null;
        bool supplierIsSelected = pendingValue.selectedSupplier != null;

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
            pendingValue.selectedEnterprises != null &&
            pendingValue.selectedEnterprises!.isNotEmpty;
        if (index == 2 && !enterprisesAreValid) {
          showSnackBarMessage(
            context,
            'Selecione pelo menos uma empresa'.hardcoded,
            backgroundColor: Colors.red,
          );
          return;
        }

        ref
            .read(uiStateControllerProvider(enterpriseCode).notifier)
            .updatePageIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Identificação'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              final isValid = ref.watch(
                pendingBuyRequestStateControllerProvider(enterpriseCode).select(
                  (s) =>
                      (s.value?.selectedBuyer != null) &&
                      (s.value?.selectedRequestType != null) &&
                      (s.value?.selectedSupplier != null),
                ),
              );
              return ValidatedBadge(
                isValid: isValid,
                materialIcon: Icons.info,
                cupertinoIcon: CupertinoIcons.info,
                isSelected: currentIndex == 0,
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          label: 'Empresas'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              return QuantityBadge(
                quantity: ref.watch(
                  pendingBuyRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.selectedEnterprises?.length),
                ),
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.business,
                  cupertinoIcon: CupertinoIcons.building_2_fill,
                ),
                isSelected: currentIndex == 1,
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              return QuantityBadge(
                quantity: ref.watch(
                  pendingBuyRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.products?.length),
                ),
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.shopping_cart,
                  cupertinoIcon: CupertinoIcons.shopping_cart,
                ),
                isSelected: currentIndex == 2,
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          label: 'Confirmação'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              final isValid = ref.watch(
                pendingBuyRequestStateControllerProvider(enterpriseCode).select(
                  (s) =>
                      (s.value?.selectedBuyer != null) &&
                      (s.value?.selectedRequestType != null) &&
                      (s.value?.selectedSupplier != null) &&
                      (s.value?.products?.isNotEmpty == true),
                ),
              );

              return ValidatedBadge(
                isValid: isValid,
                materialIcon: Icons.check_box_outlined,
                cupertinoIcon: CupertinoIcons.checkmark_square,
                isSelected: currentIndex == 3,
              );
            },
          ),
        ),
      ],
    );
  }
}
