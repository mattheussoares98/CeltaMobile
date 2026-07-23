import 'package:celta_inventario/features/buy_movement/data/models/models.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

abstract class IEcBuyMovementDatasource {
  Future<List<EcBuyMovementDtoModel>> loadShallow(
    LoadShallowBuyMovementParams params,
  );

  Future<EcBuyMovementDtoModel> loadDetails(
    LoadBuyMovementDetailsParams params,
  );
}
