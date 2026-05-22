import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/providers.dart';

part 'enterprise_manager_controller.g.dart';

@riverpod
class EnterpriseManagerController extends _$EnterpriseManagerController {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    //dont need to put in a try catch because the riverpor already treat this and return async error if throws
    return ref
        .watch(enterpriseManagerRepositoryProvider)
        .getAllEnterprisePermissions();
  }
}
