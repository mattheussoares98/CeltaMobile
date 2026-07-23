import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

abstract class IEcBuyMovementRepository {
  Future<List<EcBuyMovementDtoEntity>> loadShallow(
    LoadShallowBuyMovementParams params,
  );

  Future<EcBuyMovementDtoEntity> loadDetails(
    LoadBuyMovementDetailsParams params,
  );
}
