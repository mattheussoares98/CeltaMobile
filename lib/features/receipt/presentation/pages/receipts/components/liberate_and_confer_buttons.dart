import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';

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
          child: PrimaryButton(
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
