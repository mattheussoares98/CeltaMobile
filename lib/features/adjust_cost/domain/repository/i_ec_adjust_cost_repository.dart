import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';

abstract class IEcAdjustCostRepository {
  Future<void> adjust({
    required String workingUrl,
    required String user,
    required String accessKey,
    required AdjustCostParametersEntity parameters,
  });
}
