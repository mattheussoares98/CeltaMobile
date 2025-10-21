import '../../../../core/domain/entities/entities.dart';

abstract class ISoapLoadEnterpriseByFiltersRepository {
  Future<List<EnterpriseEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  });
}
