import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class ChangeModulesPermissionPage extends ConsumerWidget {
  final String enterpriseId;
  final String? cnpj; // This will be null for enterprise-wide changes

  const ChangeModulesPermissionPage({
    super.key,
    required this.enterpriseId,
    this.cnpj,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseAsync = ref.watch(
      permissionDetailsControllerProvider(int.parse(enterpriseId)),
    );

    final isGlobalChange = cnpj == null;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            isGlobalChange
                ? 'Alterar permissões (Global)'.hardcoded
                : 'Alterar permissões (CNPJ)'.hardcoded,
          ),
        ),
      ),
      body: AsyncValueWidget(
        value: enterpriseAsync,
        tryAgain: () {
          ref.invalidate(
            permissionDetailsControllerProvider(int.parse(enterpriseId)),
          );
        },
        data: (enterprise) {
          final subEnterprise = isGlobalChange
              ? null
              : enterprise?.subEnterprises.firstWhere(
                  (e) => e.cnpjNumber == cnpj,
                );
          return Column(
            children: [
              Text(
                "Editando ${isGlobalChange ? enterprise?.name : subEnterprise?.name}",
              ),
            ],
          );
        },
      ),
    );
  }
}
