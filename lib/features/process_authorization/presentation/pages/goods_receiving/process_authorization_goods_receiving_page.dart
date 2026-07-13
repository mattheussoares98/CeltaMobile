import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

class ProcessAuthorizationGoodsReceivingPage extends StatelessWidget {
  final int processCode;
  const ProcessAuthorizationGoodsReceivingPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(title: 'Recebimento de mercadorias'.hardcoded),
      body: const EmptyPlaceholderWidget(message: 'Recebimento de mercadorias'),
    );
  }
}
