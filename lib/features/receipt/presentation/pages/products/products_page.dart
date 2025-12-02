import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/entity.dart';

class ProductsPage extends ConsumerWidget {
  final int receiptCode;
  final ReceiptEntity? receipt;
  const ProductsPage({
    super.key,
    required this.receiptCode,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StringBuffer? buffer;
    if (receipt != null) {
      buffer = StringBuffer('[${receipt!.Numero_ProcRecebDoc.toString()}]');
      if (receipt!.EmitterName != null) {
        buffer.write(' ${receipt!.EmitterName}');
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(buffer?.toString() ?? 'Produtos'.hardcoded),
        ),
      ),
    );
  }
}
