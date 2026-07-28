import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/receipts/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ReceiptsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends ConsumerState<ReceiptsPage> {
  final observationsController = TextEditingController();
  final filterReceiptController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    observationsController.dispose();
    filterReceiptController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.observeLoading([
      selectedIndexUpdateObservationsStateControllerProvider,
    ]);

    Future<void> onRefresh() async {
      ref.invalidate(receiptsStateControllerProvider(widget.enterpriseCode));
    }

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
      refreshProvider: receiptsStateControllerProvider(widget.enterpriseCode),
      appBar: BaseAppBar(
        title: 'Recebimentos'.hardcoded,
        selectedEnterpriseCode: widget.enterpriseCode,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(
              receiptsStateControllerProvider(widget.enterpriseCode),
            ),
            tryAgain: onRefresh,
            data: (receipts) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p4),
                    child: BaseTextFormField(
                      controller: filterReceiptController,
                      hintText: 'Número|Emitente|Status|Observação'.hardcoded,
                      labelText: 'Filtrar'.hardcoded,
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: filterReceiptController,
                      builder: (_, _) {
                        final lowerCaseController = filterReceiptController.text
                            .toLowerCase();
                        final filteredReceipts = receipts
                            .where(
                              (e) =>
                                  e.Numero_ProcRecebDoc.toString().contains(
                                    lowerCaseController,
                                  ) ||
                                  e.status.description.toLowerCase().contains(
                                    lowerCaseController,
                                  ) ||
                                  e.Observacoes_ProcRecebDoc.toString()
                                      .toLowerCase()
                                      .contains(lowerCaseController) ||
                                  e.EmitterName.toString()
                                      .toLowerCase()
                                      .contains(lowerCaseController),
                            )
                            .toList();
                        return ResponsiveListFlow(
                          itemCount: filteredReceipts.length,
                          itemBuilder: (_, index) {
                            final receipt = filteredReceipts[index];

                            return ReceiptItem(
                              key: ValueKey(receipt.Numero_ProcRecebDoc),
                              receipt: receipt,
                              index: index,
                              enterpriseCode: widget.enterpriseCode,
                              observationsController: observationsController,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
