import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/enterprise/enterprise.dart';

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
