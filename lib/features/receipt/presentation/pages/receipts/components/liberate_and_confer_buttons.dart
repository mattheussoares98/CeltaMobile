import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                    ? context.l10n.alreadyReleased
                    : context.l10n.release,
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
                            title: context.l10n.attention2,
                            content: context
                                .l10n
                                .thisDocumentIsUndergoingAuthorizationAndCannotBeReleased,
                          );
                        } else {
                          final result = await showAlertDialog(
                            context: context,
                            title: context.l10n.release2,
                            defaultActionText: context.l10n.release,
                            cancelActionText: context.l10n.cancel,
                            content: context
                                .l10n
                                .areYouSureYouWantToReleaseThisDocument,
                          );
                          if (result == true && context.mounted) {
                            ref
                                .read(
                                  liberateDocumentControllerProvider(
                                    receipt.CodigoInterno_ProcRecebDoc,
                                  ).notifier,
                                )
                                .liberate();
                          }
                        }
                      },
              );
            },
          ),
        ),
        gapW8,
        Expanded(
          child: PrimaryButton(
            text: context.l10n.verifyProducts,
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
