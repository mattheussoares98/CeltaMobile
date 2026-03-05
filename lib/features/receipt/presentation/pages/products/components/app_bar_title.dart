import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entity/entity.dart';

class AppBarTitle extends StatelessWidget {
  final ReceiptEntity? receipt;
  final int enterpriseCode;
  const AppBarTitle({
    super.key,
    required this.receipt,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    StringBuffer? buffer;
    if (receipt != null) {
      buffer = StringBuffer('[${receipt!.Numero_ProcRecebDoc.toString()}]');
      if (receipt!.EmitterName != null) {
        buffer.write(' ${receipt!.EmitterName}');
      }
    }

    return DefaultAppBarTitle(
      title: buffer?.toString() ?? 'Produtos'.hardcoded,
    );
  }
}
