import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../routing/routing.dart';
import '../../../../providers.dart';
import '../../../controllers/controllers.dart';

class EditButton extends ConsumerWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleRequestLoadedCorrectly = ref.watch(
      saleRequestDetailsStateControllerProvider.select(
        (value) => value.hasValue && !value.isLoading,
      ),
    );

    return IconButton(
      onPressed: saleRequestLoadedCorrectly
          ? () {
              final args = ref.read(saleRequestArgsProvider);
              ref
                  .read(tryAccessModuleControllerProvider.notifier)
                  .tryAccess(
                    context: context,
                    route: Routes.insertUpdateSaleRequest,
                    enterpriseCode: args.enterpriseCode,
                    module: Modules.saleRequest,
                    replace: true,
                    pathParameters: {
                      'enterpriseCode': args.enterpriseCode.toString(),
                      'customerCode': args.customerCode.toString(),
                      'saleRequestId': args.saleRequestId.toString(),
                    },
                  );
            }
          : null,
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.pencil,
        materialIcon: Icons.edit,
      ),
    );
  }
}
