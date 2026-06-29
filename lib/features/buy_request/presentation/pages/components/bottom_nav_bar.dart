import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final isIdentificationValid = ref.watch(
      pendingBuyRequestStateControllerProvider(enterpriseCode).select(
        (s) =>
            (s.value?.selectedBuyer != null) &&
            (s.value?.selectedRequestType != null) &&
            (s.value?.selectedSupplier != null),
      ),
    );

    final enterprisesCount = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.selectedEnterprises?.length ?? 0),
    );

    final productsCount = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.products?.length ?? 0),
    );

    final isConfirmationValid = ref.watch(
      pendingBuyRequestStateControllerProvider(enterpriseCode).select(
        (s) =>
            (s.value?.selectedBuyer != null) &&
            (s.value?.selectedRequestType != null) &&
            (s.value?.selectedSupplier != null) &&
            (s.value?.products?.isNotEmpty == true),
      ),
    );

    return BaseBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) async {
        final pendingValue = await ref.read(
          pendingBuyRequestStateControllerProvider(enterpriseCode).future,
        );

        bool buyerIsSelected = pendingValue.selectedBuyer != null;
        bool requestTypeIsSelected = pendingValue.selectedRequestType != null;
        bool supplierIsSelected = pendingValue.selectedSupplier != null;

        if (index == 1 || index == 2) {
          if (!context.mounted) return;

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
          if (!context.mounted) return;
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
        BaseBottomNavigationBarItem(
          label: 'Identificação'.hardcoded,
          isValid: isIdentificationValid,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.info,
            cupertinoIcon: CupertinoIcons.info,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Empresas'.hardcoded,
          badgeLabel: enterprisesCount.toString(),
          platformIcon: const PlatformIcon(
            materialIcon: Icons.business,
            cupertinoIcon: CupertinoIcons.building_2_fill,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          badgeLabel: productsCount.toString(),
          platformIcon: const PlatformIcon(
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Confirmação'.hardcoded,
          isValid: isConfirmationValid,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.check_box_outlined,
            cupertinoIcon: CupertinoIcons.checkmark_square,
          ),
        ),
      ],
    );
  }
}
