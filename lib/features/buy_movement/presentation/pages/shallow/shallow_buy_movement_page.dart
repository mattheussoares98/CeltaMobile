import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowBuyMovementPage extends ConsumerWidget {
  const ShallowBuyMovementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      appBar: BaseAppBar(title: 'Compras'.hardcoded),
      body: Center(child: BaseText.headlineLarge('Implement'.hardcoded)),
    );
  }
}
