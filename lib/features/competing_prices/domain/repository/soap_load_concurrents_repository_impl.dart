import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

class SoapLoadConcurrentsRepositoryImpl
    implements ISoapLoadConcurrentsRepository {
  final ISoapLoadConcurrentsDatasource datasource;
  SoapLoadConcurrentsRepositoryImpl(this.datasource);

  @override
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String baseUrl,
    String? searchValue,
  }) async {
    final searchType = int.tryParse(searchValue ?? '') != null
        ? SearchConcurrentType.exactCode
        : SearchConcurrentType.approximateName;

    final response = await datasource.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      searchType: searchType,
      searchValue: searchValue ?? '%',
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
