import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class SupplierItem extends ConsumerWidget {
  final SupplierEntity supplier;
  final PendingBuyRequestEntity? pending;
  const SupplierItem({
    super.key,
    required this.supplier,
    required this.pending,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap() {
      final newValue = pending?.selectedSupplier == supplier ? null : supplier;
      final entity = newValue == null && pending != null
          ? PendingBuyRequestEntity(
              selectedBuyer: pending!.selectedBuyer,
              selectedSupplier: null,
              selectedEnterprises: pending?.selectedEnterprises,
            )
          : (pending ?? PendingBuyRequestEntity.empty()).copyWith(
              selectedSupplier: newValue,
            );

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(entity);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(top: Sizes.p8),
      child: InkWell(
        onTap: onTap,
        child: RadioGroup<SupplierEntity>(
          groupValue: pending?.selectedSupplier,
          onChanged: (_) {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TitleAndSubTitle(
                        title: 'Código',
                        subTitle: supplier.Code.toString(),
                      ),
                    ),
                    Radio(value: supplier),
                  ],
                ),
                TitleAndSubTitle(title: 'Nome', subTitle: supplier.Name),
                TitleAndSubTitle(
                  title: 'Nome fantasia',
                  subTitle: supplier.FantasizesName,
                ),
                TitleAndSubTitle(
                  title: 'CPF/CNPJ',
                  subTitle: supplier.CnpjCpfNumber,
                ),
                TitleAndSubTitle(
                  title: 'Tipo comércio',
                  subTitle: supplier.SupplierRegimeType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
