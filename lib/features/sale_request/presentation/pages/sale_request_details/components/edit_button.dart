import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditButton extends ConsumerWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleRequestLoadedCorrectly = ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).select((value) => value.hasValue && !value.isLoading),
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
                      'requestTypeCode': args.requestTypeCode.toString(),
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
