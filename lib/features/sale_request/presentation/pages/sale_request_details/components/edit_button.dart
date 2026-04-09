import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controllers.dart';

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

    final saleRequestLoadedCorrectly = ref.watch(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).select((value) => value.hasValue && !value.isLoading),
    );

    return IconButton(
      onPressed: saleRequestLoadedCorrectly
          ? () {
              ref
                  .read(tryAccessModuleControllerProvider.notifier)
                  .tryAccess(
                    context: context,
                    route: Routes.insertUpdateSaleRequest,
                    enterpriseCode: enterpriseCode,
                    module: Modules.saleRequest,
                    replace: true,
                    pathParameters: {
                      'enterpriseCode': enterpriseCode.toString(),
                      'customerCode': customerCode.toString(),
                      'saleRequestId': saleRequestId.toString(),
                    },
                  );
            }
          : null,
      icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
    );
  }
}
