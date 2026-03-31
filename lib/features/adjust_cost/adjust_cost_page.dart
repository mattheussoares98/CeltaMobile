import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../commom_widgets/commom_widgets.dart';

class AdjustCostPage extends StatelessWidget {
  final int enterpriseCode;
  const AdjustCostPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Ajuste de custo'.hardcoded),
      ),
      body: Center(child: Text('Ajuste de custo'.hardcoded)),
    );
  }
}
