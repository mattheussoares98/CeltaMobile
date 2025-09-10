import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../exceptions/exceptions.dart';
import '../../data/models/models.dart';
import '../../providers.dart';
import 'enterprise_permissions_controller.dart';

part 'update_permissions_controller.g.dart';

@riverpod
class UpdatePermissionsController extends _$UpdatePermissionsController
    with ErrorHandling {
  @override
  FutureOr<void> build() {}

  Future<void> saveChanges({
    required int enterpriseId,
    int? subEnterpriseId, // Null if it's a global change
    required Map<int, bool?> changes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final permissions = changes.entries.map((entry) {
        return UpdateModulePermissionModel(
          moduleId: entry.key,
          isEnabled: entry.value,
          subEnterpriseId:
              subEnterpriseId, // Only add this for specific changes
        );
      }).toList();

      if (permissions.isNotEmpty) {
        await ref
            .read(enterpriseManagerRepositoryProvider)
            .updateModulePermissions(
              enterpriseId: enterpriseId,
              permissions: permissions,
            );
      }
      // After saving, invalidate the main list to show the new data
      ref.invalidate(enterprisePermissionsProvider);
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
  }
}
