import 'package:celta_inventario/core/domain/entities/enterprise/enterprise_entity.dart';

import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';

class SoapLoadDestinyEnterprisesRepositoryImpl
    implements ISoapLoadDestinyEnterprisesRepository {
  final ISoapLoadDestinyEnterprisesDatasource datasource;
  SoapLoadDestinyEnterprisesRepositoryImpl(this.datasource);

  @override
  Future<List<EnterpriseEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
