import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsertUpdateBottomNavigationBar extends ConsumerWidget {
  const InsertUpdateBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    final isCustomerValid = ref.watch(
      insertUpdateStateControllerProvider.select(
        (state) => state.value?.customer != null,
      ),
    );

    final quantity = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.products?.length ?? 0,
      ),
    );

    final isPaymentValid = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.isPaymentValid ?? true,
      ),
    );

    return BaseBottomNavigationBar(
      currentIndex: pageIndex,
      onTap: (index) => ref
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(index),
      items: [
        BaseBottomNavigationBarItem(
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.search,
            materialIcon: Icons.search,
          ),
          label: context.l10n.products,
        ),
        BaseBottomNavigationBarItem(
          label: context.l10n.customer,
          isValid: isCustomerValid,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.person,
            cupertinoIcon: CupertinoIcons.person,
          ),
        ),
        BaseBottomNavigationBarItem(
          platformIcon: const PlatformIcon(
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.cart,
          ),
          badgeLabel: quantity > 0 ? quantity.toString() : null,
          label: context.l10n.items,
        ),
        BaseBottomNavigationBarItem(
          isValid: isPaymentValid,
          showSuccessBadge: false,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.payment,
            cupertinoIcon: CupertinoIcons.creditcard,
          ),
          label: context.l10n.payment,
        ),
        BaseBottomNavigationBarItem(
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.info,
            materialIcon: Icons.info,
          ),
          label: context.l10n.summary2,
        ),
      ],
    );
  }
}
