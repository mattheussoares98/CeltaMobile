import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

abstract class ISoapInsertUpdateResearchRepository {
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    ConcurrentEntity? concurrentToAssociate,
    int? researchCode,
    String? observations,
  });
}
