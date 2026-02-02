import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class SupplierItem extends ConsumerWidget {
  final SupplierEntity supplier;
  final bool? enabled; //TODO remove this param and treat using if onTap is null
  final VoidCallback? onTap;
  final int enterpriseCode;
  const SupplierItem({
    super.key,
    required this.supplier,
    required this.onTap,
    required this.enabled,
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
          onTap: enabled == false ? null : onTap,
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
                        title: 'Código',
                        subTitle: supplier.Code.toString(),
                      ),
                      TitleAndSubTitle(
                        title: 'CPF/CNPJ',
                        subTitle: supplier.CnpjCpfNumber,
                      ),
                      TitleAndSubTitle(title: 'Nome', subTitle: supplier.Name),
                      TitleAndSubTitle(
                        title: 'Nome fantasia',
                        subTitle: supplier.FantasizesName,
                      ),
                      TitleAndSubTitle(
                        title: 'Tipo comércio',
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
                    enabled: enabled,
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
