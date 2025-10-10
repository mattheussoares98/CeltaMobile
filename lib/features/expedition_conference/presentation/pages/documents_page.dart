import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entities.dart';

class DocumentsPage extends ConsumerWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  const DocumentsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Documentos'.hardcoded)),
      body: Center(child: Text('Documentos'.hardcoded)),
    );
  }
}
