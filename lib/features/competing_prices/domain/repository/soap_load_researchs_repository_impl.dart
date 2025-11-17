import 'package:celta_intelligence/features/competing_prices/domain/entities/research_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadResearchsRepositoryImpl implements ISoapLoadResearchsRepository {
  final ISoapLoadResearchsDatasource datasource;
  SoapLoadResearchsRepositoryImpl(this.datasource);

  @override
  Future<List<ResearchEntity>> load({
    required String crossIdentity,
    required String baseUrl,
    required int enterpriseCode,
    String? searchValue,
  }) async {
    final response = await datasource.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      enterpriseCode: enterpriseCode,
      searchValue: searchValue,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
