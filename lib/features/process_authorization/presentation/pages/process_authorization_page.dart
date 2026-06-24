import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class ProcessAuthorizationPage extends StatelessWidget {
  final int enterpriseCode;
  const ProcessAuthorizationPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Autorização de processos'.hardcoded),
      ),
      body: Center(child: Text('Implementing'.hardcoded)),
    );
  }
}
