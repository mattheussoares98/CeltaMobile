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
  final bool? enabled;
  const SupplierItem({
    super.key,
    required this.supplier,
    required this.pending,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap() {
      if (enabled == false || pending?.selectedSupplier == supplier) {
        return;
      }

      if (pending?.selectedEnterprises?.isNotEmpty == true) {
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
                  annulSelectedEnterprises: true,
                  annulProducts: true,
                );
            ref.invalidate(enterprisesStateControllerProvider);
          },
        );
      } else {
        final newValue = pending?.selectedSupplier == supplier
            ? null
            : supplier;
        ref
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(selectedSupplier: newValue);
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: Sizes.p8),
      child: InkWell(
        onTap: enabled == false ? null : onTap,
        child: RadioGroup<SupplierEntity>(
          groupValue: pending?.selectedSupplier,
          onChanged: (_) {
            onTap();
          },
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
    );
  }
}
