import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../routing/routing.dart';
import '../../../../../domain/entities/entities.dart';

class EditEnterpriseButton extends StatelessWidget {
  final EnterprisePermissionEntity enterprise;
  const EditEnterpriseButton({super.key, required this.enterprise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () {
        context.pushNamed(
          Routes.enterpriseManagerChangeModulesPermissions.name,
          pathParameters: {
            'enterpriseId': enterprise.id.toString(),
            'subEnterpriseId': 'all',
          },
        );
      },
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.pencil
            : Icons.edit,
      ),
    );
  }
}
