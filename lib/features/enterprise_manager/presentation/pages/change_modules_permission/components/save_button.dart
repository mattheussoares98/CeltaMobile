import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  final int enterpriseId;
  final int? subEnterpriseId;
  final Map<int, bool?> permissionChanges;
  final TextEditingController urlInUseController;
  final GlobalKey<FormState> formKey;
  final bool isGlobalChange;
  const SaveButton({
    super.key,
    required this.enterpriseId,
    required this.subEnterpriseId,
    required this.permissionChanges,
    required this.urlInUseController,
    required this.formKey,
    required this.isGlobalChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final isLoading = ref.watch(
      updatePermissionsControllerProvider.select((value) => value.isLoading),
    );

    return IconButton(
      onPressed: isLoading
          ? null
          : () {
              if (isGlobalChange && formKey.currentState?.validate() != true) {
                return;
              }
              ref
                  .read(updatePermissionsControllerProvider.notifier)
                  .saveChanges(
                    enterpriseId: enterpriseId,
                    subEnterpriseId: subEnterpriseId,
                    changes: permissionChanges,
                    urlInUse: urlInUseController.text,
                  );
            },
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.checkmark_alt
            : Icons.save,
      ),
    );
  }
}
