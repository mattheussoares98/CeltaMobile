import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  final int enterpriseId;
  final int? subEnterpriseId;
  final Map<int, bool?> permissionChanges;
  final TextEditingController baseUrlController;
  final GlobalKey<FormState> formKey;
  const SaveButton({
    super.key,
    required this.enterpriseId,
    required this.subEnterpriseId,
    required this.permissionChanges,
    required this.baseUrlController,
    required this.formKey,
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
              if (formKey.currentState?.validate() != true) return;
              ref
                  .read(updatePermissionsControllerProvider.notifier)
                  .saveChanges(
                    enterpriseId: enterpriseId,
                    subEnterpriseId: subEnterpriseId,
                    changes: permissionChanges,
                    baseUrl: baseUrlController.text,
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
