import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/enterprise/enterprise.dart';

part 'enabled_modules_by_enterprise_name_state_controller.g.dart';

@riverpod
class EnabledModulesByEnterpriseNameStateController
    extends _$EnabledModulesByEnterpriseNameStateController {
  @override
  FutureOr<List<EnabledModulesByCnpjEntity>> build(
    String enterpriseName,
  ) async {
    final repository = ref.read(enterpriseRepositoryProvider);

    return await repository.getEnabledModulesByEnterpriseName(enterpriseName);
  }
}
