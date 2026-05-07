import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';

import '../../../data/datasource/request_type/request_type.dart';

class EcGetRequestTypesRepositoryImpl implements IEcGetRequestTypesRepository {
  final IEcGetRequestTypesDatasource datasource;

  EcGetRequestTypesRepositoryImpl(this.datasource);

  @override
  Future<List<BSFRequestTypeEntity>> search({
    required EcRequestTypeParametersEntity parameters,
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final result = await datasource.search(
      parameters: parameters,
      enterpriseCode: enterpriseCode,
      params: params,
    );
    return result.map((e) => e.toEntity()).toList();
  }
}
