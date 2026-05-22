import 'package:celta_inventario/features/competing_prices/domain/entities/research_entity.dart';

import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_inventario/features/competing_prices/domain/repository/repository.dart';

class SoapLoadResearchsRepositoryImpl implements ISoapLoadResearchsRepository {
  final ISoapLoadResearchsDatasource datasource;
  SoapLoadResearchsRepositoryImpl(this.datasource);

  @override
  Future<List<ResearchEntity>> load({
    required String crossIdentity,
    required String workingUrl,
    required int enterpriseCode,
    String? searchValue,
  }) async {
    final response = await datasource.load(
      crossIdentity: crossIdentity,
      workingUrl: workingUrl,
      enterpriseCode: enterpriseCode,
      searchValue: searchValue,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
