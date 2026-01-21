import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../routing/routes.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import 'components/components.dart';

class OriginEnterprisesPage extends ConsumerWidget {
  final int requestTypeCode;
  const OriginEnterprisesPage({super.key, required this.requestTypeCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Empresa de origem'.hardcoded)),
      body: AsyncValueWidget(
        value: ref.watch(enterprisesStateControllerProvider()),
        tryAgain: () {
          ref.invalidate(enterprisesStateControllerProvider());
        },
        data: (enterprises) {
          return EnterpriseItems(
            enterprises: enterprises,
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
                Routes.transferRequestDestinyEnterprises.name,
                pathParameters: {
                  'requestTypeCode': requestTypeCode.toString(),
                  'enterpriseOriginCode': enterprise.Code.toString(),
                },
              );
            },
            onRefresh: () {
              ref.invalidate(enterprisesStateControllerProvider());
            },
          );
        },
      ),
    );
  }
}
