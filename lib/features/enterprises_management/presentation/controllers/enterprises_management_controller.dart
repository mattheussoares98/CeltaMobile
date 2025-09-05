import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprises_management_controller.g.dart';

@riverpod
class EnterpriseManagerController extends _$EnterpriseManagerController {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    // Fetch the initial data using the repository provider
    return ref
        .watch(enterpriseRepositoryProvider)
        .getAllEnterprisePermissions();
  }
}
