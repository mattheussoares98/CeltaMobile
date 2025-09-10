import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeEnabledModulesPage extends ConsumerWidget {
  final String enterpriseId;
  final String? cnpj; // This will be null for enterprise-wide changes

  const ChangeEnabledModulesPage({
    super.key,
    required this.enterpriseId,
    this.cnpj,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the IDs to fetch the correct data and build your UI
    final isGlobalChange = cnpj == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isGlobalChange
              ? 'Alterar Permissões (Global)'.hardcoded
              : 'Alterar Permissões (CNPJ)'.hardcoded,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Editing Enterprise ID: $enterpriseId'),
            if (!isGlobalChange) Text('Editing CNPJ ID: $cnpj'),
            // ... Build your list of modules with switches here ...
          ],
        ),
      ),
    );
  }
}
