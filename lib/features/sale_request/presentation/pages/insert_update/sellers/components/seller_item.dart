import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerItem extends ConsumerWidget {
  final EcSellerEntity seller;
  const SellerItem({super.key, required this.seller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.seller?.code == seller.Id,
      ),
    );

    return DefaultCheckBox(
      name: seller.Name,
      enabled: enabled,
      onChanged: (_) {
        ref
            .read(insertUpdateStateControllerProvider.notifier)
            .changeSeller(seller);
      },
    );
  }
}
