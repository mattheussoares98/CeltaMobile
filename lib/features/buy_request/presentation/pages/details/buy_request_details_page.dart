import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyRequestDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int buyRequestCode;
  const BuyRequestDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyRequestCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'Detalhes'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: EmptyPlaceholderWidget(message: 'só implementar'.hardcoded),
    );
  }
}
