import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DestinyEnterprisesPage extends ConsumerWidget {
  final int requestTypeCode;
  final int enterpriseOriginCode;
  const DestinyEnterprisesPage({
    super.key,
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = destinyEnterprisesStateControllerProvider(
      enterpriseOriginCode: enterpriseOriginCode,
      requestTypeCode: requestTypeCode,
    );

    Future<void> onRefresh() async {
      ref.invalidate(provider);
    }

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: context.l10n.destinationCompany,
        selectedEnterpriseCode: enterpriseOriginCode,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: onRefresh,
            data: (enterprises) {
              return EnterpriseItems(
                enterprises: enterprises
                    .where((e) => e.Code != enterpriseOriginCode)
                    .toList(),
                onTap: (enterprise) async {
                  bool moduleIsEnabled = await ref.read(
                    moduleIsEnabledControllerProvider(
                      Modules.transferRequest,
                      enterprise.CnpjNumber!,
                    ).future,
                  );

                  if (!context.mounted) return;

                  if (!moduleIsEnabled) {
                    showAlertDialog(
                      context: context,
                      title: context.l10n.moduleDisabled,
                      content: context.l10n.moduleDisabledContactAdmin,
                    );
                    return;
                  }

                  context.goNamed(
                    Routes.transferRequestProductsManagement.name,
                    pathParameters: {
                      'requestTypeCode': requestTypeCode.toString(),
                      'enterpriseOriginCode': enterpriseOriginCode.toString(),
                      'enterpriseDestinyCode': enterprise.Code.toString(),
                      'enterpriseCode': enterpriseOriginCode.toString(),
                    },
                  );
                },
                onRefresh: onRefresh,
              );
            },
          );
        },
      ),
    );
  }
}
