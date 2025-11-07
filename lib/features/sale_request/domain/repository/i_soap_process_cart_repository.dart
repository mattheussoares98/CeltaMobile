import '../entities/entities.dart';

abstract class ISoapProcessCartRepository {
  Future<ProcessedCartEntity> process({
    required String crossId,
    required String baseUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<CartProductEntity> products,
  });
}
