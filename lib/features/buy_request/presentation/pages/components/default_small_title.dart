import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class DefaultSmallTitle extends StatelessWidget {
  final String title;
  const DefaultSmallTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.theme.textTheme.titleSmall?.copyWith(
        fontStyle: FontStyle.italic,
        color: context.theme.primaryColor,
      ),
    );
  }
}
