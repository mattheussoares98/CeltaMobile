import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class SynchronizerPage extends StatelessWidget {
  const SynchronizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(title: 'Sincronizador'.hardcoded),
      body: Center(child: Text('Hello?'.hardcoded)),
    );
  }
}
