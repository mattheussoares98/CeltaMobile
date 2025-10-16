import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
    final value = ref.watch(inventoryStateControllerProvider(enterpriseCode));
    return Scaffold(
      appBar: AppBar(title: Text('Contagens'.hardcoded)),
      body: AsyncValueWidget(
        value: value,
        tryAgain: () {
          ref.invalidate(inventoryStateControllerProvider(enterpriseCode));
        },
        data: (inventory) {
          final countings = inventory?.countings
              .where(
                (e) => codigoInternoInventario == e.CodigoInternoInventario,
              )
              .toList();
          if (countings == null || countings.isEmpty) {
            return Text(
              'Não foram encontradas contagens para esse processe de inventário. Crie pelo menos uma contagem'
                  .hardcoded,
            );
          }

          return CountingsItems(countings: countings);
        },
      ),
    );
  }
}
