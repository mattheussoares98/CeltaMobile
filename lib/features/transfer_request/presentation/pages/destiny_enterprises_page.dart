import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/components.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Empresa de destino'.hardcoded),
        actions: [ReloadIconButton(provider: provider)],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: () {
              ref.invalidate(provider);
            },
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

                  if (!moduleIsEnabled) {
                    showAlertDialog(
                      context: context,
                      title: 'Módulo desabilitado'.hardcoded,
                      content:
                          'O módulo está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'
                              .hardcoded,
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
                onRefresh: () {
                  ref.invalidate(provider);
                },
              );
            },
          );
        },
      ),
    );
  }
}
