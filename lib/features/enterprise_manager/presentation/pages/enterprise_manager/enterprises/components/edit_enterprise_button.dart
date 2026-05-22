import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';

class EditEnterpriseButton extends StatelessWidget {
  final EnterprisePermissionEntity enterprise;
  const EditEnterpriseButton({super.key, required this.enterprise});

  @override
  Widget build(BuildContext context) {
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
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.pencil,
        materialIcon: Icons.edit,
      ),
    );
  }
}
