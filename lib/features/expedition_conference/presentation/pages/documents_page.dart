import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentsPage extends ConsumerWidget {
  final int enterpriseCode;
  const DocumentsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Documentos'.hardcoded)),
      body: Center(child: Text('Documentos'.hardcoded)),
    );
  }
}
