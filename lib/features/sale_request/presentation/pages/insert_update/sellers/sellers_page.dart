import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/sellers/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellersPage extends ConsumerWidget {
  const SellersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: CustomScrollView(
        slivers: [
          AsyncValueWidget(
            value: ref.watch(sellersStateControllerProvider),
            tryAgain: () => ref.invalidate(sellersStateControllerProvider),
            isSliver: true,
            data: (sellers) {
              return ResponsiveListFlow(
                itemCount: sellers.length,
                isSliver: true,
                itemBuilder: (context, index) {
                  final seller = sellers[index];
                  return SellerItem(
                    key: ValueKey(seller.Id),
                    seller: seller,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
