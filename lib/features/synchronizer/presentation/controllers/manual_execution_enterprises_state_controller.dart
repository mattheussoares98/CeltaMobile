// lib/features/synchronizer/presentation/controllers/manual_execution_enterprises_state_controller.dart
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manual_execution_enterprises_state_controller.g.dart';

@riverpod
class ManualExecutionEnterprisesStateController
    extends _$ManualExecutionEnterprisesStateController {
  @override
  FutureOr<List<ManualExecutionEnterpriseEntity>> build() async {
    ref.cache(300);

    final ecParams = await ref.watch(ecRequestParamsProvider().future);
    final enterprises = await ref.read(
      enterprisesStateControllerProvider().future,
    );

    final repository = ref.read(
      ecSynchronizerManualExecutionRepositoryProvider,
    );
    return await repository.searchManualExecutionEnterprises(
      ecParams,
      SearchManualExecutionEnterprisesParamsEntity(
        enterpriseCodes: enterprises.map((e) => e.Code!).toList(),
      ),
    );
  }
}
