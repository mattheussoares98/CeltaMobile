import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';

class LiberateAndConferButtons extends ConsumerWidget {
  final ReceiptEntity receipt;
  final int enterpriseCode;
  const LiberateAndConferButtons({
    super.key,
    required this.receipt,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      liberateDocumentControllerProvider(receipt.CodigoInterno_ProcRecebDoc),
      (p, n) {
        n.showAlertDialogOnError(context);
      },
    );

    return Row(
      children: [
        Expanded(
          child: Consumer(
            builder: (_, ref, _) {
              return PrimaryButton(
                text: receipt.status == Status.liberatedForEntry
                    ? 'Já liberado'.hardcoded
                    : 'Liberar'.hardcoded,
                isLoading: ref.watch(
                  liberateDocumentControllerProvider(
                    receipt.CodigoInterno_ProcRecebDoc,
                  ).select((s) => s.isLoading),
                ),
                onPressed: receipt.status == Status.liberatedForEntry
                    ? null
                    : () async {
                        if (receipt.status == Status.inProcessOfAuthorization) {
                          showAlertDialog(
                            context: context,
                            title: 'Atenção'.hardcoded,
                            content:
                                'Esse documento está em processo de autorização e por isso não pode ser liberado'
                                    .hardcoded,
                          );
                        } else {
                          showAlertDialog(
                            context: context,
                            title: 'Liberar?'.hardcoded,
                            defaultActionText: 'Liberar'.hardcoded,
                            cancelActionText: 'Cancelar'.hardcoded,
                            content:
                                'Tem certeza que deseja liberar esse documento?'
                                    .hardcoded,
                            onOkPressed: () {
                              ref
                                  .read(
                                    liberateDocumentControllerProvider(
                                      receipt.CodigoInterno_ProcRecebDoc,
                                    ).notifier,
                                  )
                                  .liberate();
                            },
                          );
                        }
                      },
              );
            },
          ),
        ),
        gapW8,
        Expanded(
          child: PrimaryButton(
            text: 'Conferir produtos'.hardcoded,
            onPressed: () {
              context.goNamed(
                Routes.receiptProducts.name,
                extra: receipt,
                pathParameters: {
                  'enterpriseCode': enterpriseCode.toString(),
                  'receiptCode': receipt.CodigoInterno_ProcRecebDoc.toString(),
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
