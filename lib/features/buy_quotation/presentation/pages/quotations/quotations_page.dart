import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controller.dart';
import 'components/components.dart';

class QuotationsPage extends ConsumerWidget {
  final int enterpriseCode;
  const QuotationsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Cotações'.hardcoded),
        actions: [
          ReloadIconButton(
            provider: buyQuotationsStateControllerProvider(enterpriseCode),
          ),
        ],
      ),
      body: QuotationsItems(enterpriseCode: enterpriseCode),
      floatingActionButton: FloatingActionButton(
        child: Icon(isIOS ? CupertinoIcons.add : Icons.add),
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
