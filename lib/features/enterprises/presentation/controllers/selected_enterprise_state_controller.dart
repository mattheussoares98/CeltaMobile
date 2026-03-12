import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/services/services.dart';
import '../../providers.dart';

part 'selected_enterprise_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedEnterpriseStateController
    extends _$SelectedEnterpriseStateController {
  @override
  EnterpriseEntity? build() {
    return null;
  }

  Future<void> selectEnterprise(EnterpriseEntity enterprise) async {
    state = enterprise;
    final repository = ref.read(lastSelectedEnterpriseCodeRepositoryProvider);
    repository.update(enterprise.Code!);

    final enterpriseName = await ref.read(
      userSessionProvider.selectAsync(
        (s) => s?.enterprise?.name ?? 'error to load',
      ),
    );

    ref.read(crashlyticsServiceProvider).setCustomKeys([
      CrashlyticsCustomKeyEntity(key: 'enterprise', value: enterpriseName),
      CrashlyticsCustomKeyEntity(
        key: 'selected_enterprise',
        value: enterprise.name,
      ),
    ]);
  }
}
