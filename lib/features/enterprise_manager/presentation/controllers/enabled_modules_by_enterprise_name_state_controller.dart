import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

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
