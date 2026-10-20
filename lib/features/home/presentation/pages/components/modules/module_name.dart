import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class ModuleName extends StatelessWidget {
  const ModuleName({super.key, required this.module});

  final Modules module;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Text(
        context.l10n.moduleName(module),
        textAlign: TextAlign.center,
        style: context.theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
