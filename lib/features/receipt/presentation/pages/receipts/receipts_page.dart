import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class ReceiptsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ReceiptsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends ConsumerState<ReceiptsPage> {
  final observationsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    observationsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(
      receiptsStateControllerProvider(widget.enterpriseCode),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Recebimentos'.hardcoded)),
      body: AsyncValueWidget(
        value: asyncValue,
        tryAgain: () => ref.invalidate(
          receiptsStateControllerProvider(widget.enterpriseCode),
        ),
        data: (receipts) {
          return ResponsiveListFlow(
            itemCount: receipts.length,
            itemBuilder: (_, index) {
              final receipt = receipts[index];

              return ReceiptItem(
                receipt: receipt,
                index: index,
                enterpriseCode: widget.enterpriseCode,
                observationsController: observationsController,
              );
            },
          );
        },
      ),
    );
  }
}
