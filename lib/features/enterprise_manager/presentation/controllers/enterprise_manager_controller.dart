import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprise_manager_controller.g.dart';

@riverpod
class EnterpriseManagerController extends _$EnterpriseManagerController {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    //TODO put in try catch
    return ref
        .watch(enterpriseRepositoryProvider)
        .getAllEnterprisePermissions();
  }
}
