import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../routing/routing.dart';

class DefaultModuleButton extends StatelessWidget {
  final EnterpriseEntity? selectedEnterprise;
  final AppRoute route;
  final Map<String, String>? pathParameters;
  final Map<String, dynamic>? extra;

  const DefaultModuleButton({
    super.key,
    required this.selectedEnterprise,
    required this.route,
    this.pathParameters,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: route.module,
      onPressed: selectedEnterprise == null
          ? null
          : () {
              context.goNamed(
                route.name,
                pathParameters: pathParameters ?? {},
                extra: extra,
              );
            },
    );
  }
}
