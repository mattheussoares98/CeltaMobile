import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/quotations/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuotationsPage extends ConsumerWidget {
  final int enterpriseCode;
  const QuotationsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: buyQuotationsStateControllerProvider(enterpriseCode),
      appBar: BaseAppBar(
        title: context.l10n.quotations,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: QuotationsItems(enterpriseCode: enterpriseCode),
      floatingActionButton: FloatingActionButton(
        child: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.add,
          materialIcon: Icons.add,
        ),
        onPressed: () {
          context.goNamed(
            Routes.buyQuotationInsertUpdate.name,
            pathParameters: {
              'enterpriseCode': enterpriseCode.toString(),
              'code': '0',
            },
          );
        },
      ),
    );
  }
}
