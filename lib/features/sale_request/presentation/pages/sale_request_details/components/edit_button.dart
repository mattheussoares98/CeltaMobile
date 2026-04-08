import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../routing/routing.dart';

class EditButton extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const EditButton({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return IconButton(
      onPressed: () {
        ref
            .read(tryAccessModuleControllerProvider.notifier)
            .tryAccess(
              context: context,
              route: Routes.insertUpdateSaleRequest,
              enterpriseCode: enterpriseCode,
              module: Modules.saleRequest,
              pathParameters: {
                'enterpriseCode': enterpriseCode.toString(),
                'customerCode': customerCode.toString(),
                'saleRequestId': saleRequestId.toString(),
              },
            );
      },
      icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
    );
  }
}
