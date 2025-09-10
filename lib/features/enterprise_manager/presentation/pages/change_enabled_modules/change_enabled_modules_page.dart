import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeEnabledModulesPage extends ConsumerWidget {
  final String? cnpj;
  final String enterpriseId;
  const ChangeEnabledModulesPage({
    super.key,
    required this.cnpj,
    required this.enterpriseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Center(child: Text('ChangeEnabledModulesPage')));
  }
}
