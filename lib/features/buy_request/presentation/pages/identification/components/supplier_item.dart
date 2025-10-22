import 'package:celta_intelligence/localization/string_hardcoded.dart';
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
          ? pending!.annulValue(annulSelectedSupplier: true)
          : (pending ?? PendingBuyRequestEntity.empty()).copyWith(
              selectedSupplier: newValue,
            );

      if (pending?.selectedEnterprises != null &&
          pending!.selectedEnterprises!.isNotEmpty) {
        //TODO add validation when has products too
        showAlertDialog(
          context: context,
          title: 'Alterar fornecedor?'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          content:
              'Ao alterar o fornecedor, todas empresas e produtos selecionados serão removidos'
                  .hardcoded,
          onOkPressed: () {
            ref
                .read(pendingBuyRequestStateControllerProvider.notifier)
                .updatePending(
                  entity.annulValue(annulSelectedEnterprises: true),
                );
            ref.invalidate(enterprisesStateControllerProvider);
          },
        );
      } else {
        ref
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(entity);
      }
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
