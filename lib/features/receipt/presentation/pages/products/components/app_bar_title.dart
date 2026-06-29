import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

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

    return BaseAppBarTitle(title: buffer?.toString() ?? 'Produtos'.hardcoded);
  }
}
