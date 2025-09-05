import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprises_management_controller.g.dart';

@riverpod
class EnterprisesManagementController
    extends _$EnterprisesManagementController {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    return ref
        .watch(enterpriseRepositoryProvider)
        .getAllEnterprisePermissions();
  }
}
