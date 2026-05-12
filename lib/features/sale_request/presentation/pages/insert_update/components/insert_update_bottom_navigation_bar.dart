import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class InsertUpdateBottomNavigationBar extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const InsertUpdateBottomNavigationBar({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    return BottomNavigationBar(
      currentIndex: pageIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => ref
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.search,
            materialIcon: Icons.search,
          ),
          label: 'Produtos'.hardcoded,
        ),
        BottomNavigationBarItem(
          label: 'Cliente'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              return ValidatedBadge(
                isSelected: pageIndex == 1,
                isValid: ref.watch(
                  insertUpdateStateControllerProvider(
                    enterpriseCode: enterpriseCode,
                    customerCode: customerCode,
                    saleRequestId: saleRequestId,
                  ).select((state) => state.value?.customer != null),
                ),
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.person,
                  cupertinoIcon: CupertinoIcons.person,
                ),
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          icon: Consumer(
            builder: (context, ref, child) {
              final quantity = ref.watch(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                ).select((s) => s.value?.products?.length ?? 0),
              );

              return QuantityBadge(
                quantity: quantity,
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.shopping_cart,
                  cupertinoIcon: CupertinoIcons.cart,
                ),
                isSelected: pageIndex == 2,
              );
            },
          ),
          label: 'Itens'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: Consumer(
            builder: (context, ref, child) {
              final totalsMatch = ref.watch(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                ).select((s) {
                  final value = s.value;
                  if (value == null) return true;

                  // Use a small epsilon for double comparison to avoid precision issues
                  return value.totalPayments == 0 ||
                      (value.totalProductsLiquid - value.totalPayments).abs() <
                          0.001;
                }),
              );

              return ValidatedBadge(
                isValid: totalsMatch,
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.payment,
                  cupertinoIcon: CupertinoIcons.creditcard,
                ),
                isSelected: pageIndex == 3,
                showSuccessBadge: false,
              );
            },
          ),
          label: 'Pagamento'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.info,
            materialIcon: Icons.info,
          ),
          label: 'Resumo'.hardcoded,
        ),
      ],
    );
  }
}
