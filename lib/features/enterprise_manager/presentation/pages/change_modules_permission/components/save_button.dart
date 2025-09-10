import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  final int enterpriseId;
  final int? subEnterpriseId;
  final Map<int, bool?> permissionChanges;
  const SaveButton({
    super.key,
    required this.enterpriseId,
    required this.subEnterpriseId,
    required this.permissionChanges,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final updatePermissionsState = ref.watch(
      updatePermissionsControllerProvider,
    );

    return IconButton(
      onPressed: updatePermissionsState.isLoading
          ? null
          : () {
              ref
                  .read(updatePermissionsControllerProvider.notifier)
                  .saveChanges(
                    enterpriseId: enterpriseId,
                    subEnterpriseId: subEnterpriseId,
                    changes: permissionChanges,
                  );
            },
      icon: Icon(
        theme.platform != TargetPlatform.iOS
            ? CupertinoIcons.checkmark_alt
            : Icons.save,
      ),
    );
  }
}
