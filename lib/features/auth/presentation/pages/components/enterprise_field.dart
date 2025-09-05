import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../localization/string_hardcoded.dart';

class EnterpriseField extends StatelessWidget {
  final TextEditingController enterpriseController;
  const EnterpriseField({super.key, required this.enterpriseController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: enterpriseController,
      decoration: AppDecorations.input(
        context: context,
        labelText: 'Empresa'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.building_2_fill
              : Icons.business,
        ),
      ),
    );
  }
}
