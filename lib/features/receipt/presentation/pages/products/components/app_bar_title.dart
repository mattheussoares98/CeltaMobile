import 'package:flutter/material.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entity/entity.dart';

class AppBarTitle extends StatelessWidget {
  final ReceiptEntity? receipt;
  const AppBarTitle({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    StringBuffer? buffer;
    if (receipt != null) {
      buffer = StringBuffer('[${receipt!.Numero_ProcRecebDoc.toString()}]');
      if (receipt!.EmitterName != null) {
        buffer.write(' ${receipt!.EmitterName}');
      }
    }

    return FittedBox(child: Text(buffer?.toString() ?? 'Produtos'.hardcoded));
  }
}
