import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class DefaultSmallTitle extends StatelessWidget {
  final String title;
  const DefaultSmallTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultText.title(
      title,
      color: context.theme.primaryColor,
      fontStyle: FontStyle.italic,
    );
  }
}
