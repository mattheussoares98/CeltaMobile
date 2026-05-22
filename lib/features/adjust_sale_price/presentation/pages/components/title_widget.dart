import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool? enabled;
  const TitleWidget({super.key, required this.title, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.theme.textTheme.titleMedium?.copyWith(
        color: enabled == true ? null : context.theme.disabledColor,
      ),
    );
  }
}
