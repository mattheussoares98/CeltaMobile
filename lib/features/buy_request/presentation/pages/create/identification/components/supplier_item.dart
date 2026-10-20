import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';

class SupplierItem extends ConsumerWidget {
  final SupplierEntity supplier;
  final VoidCallback? onTap;
  final int enterpriseCode;
  const SupplierItem({
    super.key,
    required this.supplier,
    required this.onTap,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.selectedSupplier),
    );

    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: Sizes.p8),
        child: InkWell(
          onTap: onTap,
          child: RadioGroup<SupplierEntity>(
            groupValue: selectedSupplier,
            onChanged: (_) => onTap?.call(),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: context.l10n.code,
                        subTitle: supplier.Code.toString(),
                      ),
                      TitleAndSubTitle(
                        title: context.l10n.cpfCnpj,
                        subTitle: supplier.CnpjCpfNumber,
                      ),
                      TitleAndSubTitle(
                        title: context.l10n.name,
                        subTitle: supplier.Name,
                      ),
                      TitleAndSubTitle(
                        title: context.l10n.tradeName,
                        subTitle: supplier.FantasizesName,
                      ),
                      TitleAndSubTitle(
                        title: context.l10n.tradeType,
                        subTitle: supplier.SupplierRegimeType,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Radio(
                    value: supplier,
                    enabled: onTap != null,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
