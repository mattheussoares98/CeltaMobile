import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class NotImplementedDetailType extends StatelessWidget {
  const NotImplementedDetailType({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BaseText.error(
        'A visualização desse tipo de erro ainda não foi implementada'
            .hardcoded,
      ),
    );
  }
}
