import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class DefaultSmallTitle extends StatelessWidget {
  final String title;
  const DefaultSmallTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BaseText.title(
      title,
      color: context.theme.primaryColor,
      fontStyle: FontStyle.italic,
    );
  }
}
