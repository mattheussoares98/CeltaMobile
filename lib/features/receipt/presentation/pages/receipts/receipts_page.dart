import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Recebimentos'.hardcoded)),
          body: AsyncValueWidget(
            value: ref.watch(
              receiptsStateControllerProvider(widget.enterpriseCode),
            ),
            tryAgain: () => ref.invalidate(
              receiptsStateControllerProvider(widget.enterpriseCode),
            ),
            data: (receipts) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(
                    receiptsStateControllerProvider(widget.enterpriseCode),
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p4),
                      child: DefaultTextFormField(
                        controller: filterReceiptController,
                        hintText: 'Número|Emitente|Status|Observação'.hardcoded,
                        labelText: 'Filtrar'.hardcoded,
                      ),
                    ),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: filterReceiptController,
                        builder: (_, _) {
                          final lowerCaseController = filterReceiptController
                              .text
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
                ),
              );
            },
          ),
        ),
        LoadingPage(
          providers: [selectedIndexUpdateObservationsStateControllerProvider],
        ),
      ],
    );
  }
}
