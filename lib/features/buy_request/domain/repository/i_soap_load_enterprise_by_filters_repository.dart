import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapLoadEnterpriseByFiltersRepository {
  Future<List<EnterpriseEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  });
}
