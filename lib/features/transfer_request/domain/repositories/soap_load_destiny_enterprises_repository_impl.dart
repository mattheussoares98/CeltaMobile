import 'package:celta_intelligence/core/domain/entities/enterprise/enterprise_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapLoadDestinyEnterprisesRepositoryImpl
    implements ISoapLoadDestinyEnterprisesRepository {
  final ISoapLoadDestinyEnterprisesDatasource datasource;
  SoapLoadDestinyEnterprisesRepositoryImpl(this.datasource);

  @override
  Future<List<EnterpriseEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    final response = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
