import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool? enabled;
  const TitleWidget({super.key, required this.title, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return BaseText.titleMedium(
      title,
      color: enabled == true ? null : context.theme.disabledColor,
    );
  }
}
