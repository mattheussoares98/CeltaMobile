import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  final int enterpriseId;
  final int? subEnterpriseId;
  final Map<int, bool?> permissionChanges;
  final TextEditingController remoteHttpUrlController;
  final TextEditingController remoteHttpsUrlController;
  final TextEditingController localHttpUrlController;
  final TextEditingController localHttpsUrlController;
  final GlobalKey<FormState> formKey;
  final bool isGlobalChange;
  const SaveButton({
    super.key,
    required this.enterpriseId,
    required this.subEnterpriseId,
    required this.permissionChanges,
    required this.remoteHttpUrlController,
    required this.remoteHttpsUrlController,
    required this.localHttpUrlController,
    required this.localHttpsUrlController,
    required this.formKey,
    required this.isGlobalChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    remoteHttpUrl: remoteHttpUrlController.text,
                    localHttpUrl: localHttpUrlController.text,
                    remoteHttpsUrl: remoteHttpsUrlController.text,
                    localHttpsUrl: localHttpsUrlController.text,
                  );
            },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.checkmark_alt,
        materialIcon: Icons.save,
      ),
    );
  }
}
