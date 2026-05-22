import 'package:celta_inventario/features/adjust_cost/data/model/model.dart';

abstract class IEcAdjustCostDatasource {
  Future<void> adjust({
    required String workingUrl,
    required String user,
    required String accessKey,
    required AdjustCostParametersModel parameters,
  });
}
