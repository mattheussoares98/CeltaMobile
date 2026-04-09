import '../../../data/datasource/request_type/request_type.dart';
import '../../entities/entities.dart';
import './request_type.dart';

class EcGetRequestTypesRepositoryImpl implements IEcGetRequestTypesRepository {
  final IEcGetRequestTypesDatasource datasource;

  EcGetRequestTypesRepositoryImpl(this.datasource);

  @override
  Future<List<BSFRequestTypeEntity>> search({
    required BSFSearchRequestTypeParametersEntity parameters,
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
