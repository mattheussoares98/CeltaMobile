import 'package:celta_intelligence/core/domain/entities/enterprise/enterprise_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadEnterpriseByFiltersRepositoryImpl
    implements ISoapLoadEnterpriseByFiltersRepository {
  final ISoapLoadEnterpriseByFiltersDatasource datasource;
  SoapLoadEnterpriseByFiltersRepositoryImpl(this.datasource);

  @override
  Future<List<EnterpriseEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      supplierCode: supplierCode,
      requestTypeCode: requestTypeCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
