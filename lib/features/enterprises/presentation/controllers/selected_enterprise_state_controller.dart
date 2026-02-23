import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../providers.dart';

part 'selected_enterprise_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedEnterpriseStateController
    extends _$SelectedEnterpriseStateController {
  @override
  EnterpriseEntity? build() {
    return null;
  }

  void selectEnterprise(EnterpriseEntity enterprise) {
    state = enterprise;
    final repository = ref.read(lastSelectedEnterpriseCodeRepositoryProvider);
    repository.update(enterprise.Code!);
  }
}
