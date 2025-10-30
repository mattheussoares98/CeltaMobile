import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/enterprise_manager/domain/entities/entities.dart';
import '../../../../features/enterprise_manager/providers.dart';

part 'enabled_modules_by_enterprise_name_state_controller.g.dart';

@riverpod
class EnabledModulesByEnterpriseNameStateController
    extends _$EnabledModulesByEnterpriseNameStateController {
  @override
  FutureOr<List<EnabledModulesByCnpjEntity>> build(
    String enterpriseName,
  ) async {
    final repository = ref.watch(enterpriseManagerRepositoryProvider);

    return await repository.getEnabledModulesByEnterpriseName(enterpriseName);
  }
}
