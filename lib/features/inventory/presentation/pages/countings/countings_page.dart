import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/inventory/presentation/pages/countings/components/components.dart';

class CountingsPage extends ConsumerWidget {
  final int codigoInternoInventario;
  final int enterpriseCode;
  const CountingsPage({
    super.key,
    required this.codigoInternoInventario,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countings = ref
        .watch(
          inventoryStateControllerProvider(enterpriseCode).select(
            (s) => s.value?.countings.where(
              (e) => e.CodigoInternoInventario == codigoInternoInventario,
            ),
          ),
        )
        ?.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Contagens'.hardcoded)),
      body: (countings == null || countings.isEmpty)
          ? Text(
              'Não foram encontradas contagens para esse processe de inventário. Crie pelo menos uma contagem'
                  .hardcoded,
            )
          : CountingsItems(
              countings: countings,
              enterpriseCode: enterpriseCode,
              codigoInternoInventario: codigoInternoInventario,
            ),
    );
  }
}
