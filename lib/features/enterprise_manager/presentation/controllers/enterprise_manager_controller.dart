import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprise_manager_controller.g.dart';

@riverpod
class EnterpriseManagerController extends _$EnterpriseManagerController {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    //dont need to put in a try catch because the riverpor already treat this and return async error if throws
    return ref
        .watch(enterpriseRepositoryProvider)
        .getAllEnterprisePermissions();
  }
}
