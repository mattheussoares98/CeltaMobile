import '../../data/datasource/datasource.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class SoapConcurrentsRepositoryImpl implements ISoapConcurrentsRepository {
  final ISoapConcurrentsDatasource datasource;
  SoapConcurrentsRepositoryImpl(this.datasource);

  @override
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String urlInUse,
    String? searchValue,
  }) async {
    final searchType = int.tryParse(searchValue ?? '') != null
        ? SearchConcurrentType.exactCode
        : SearchConcurrentType.approximateName;

    final response = await datasource.load(
      crossIdentity: crossIdentity,
      urlInUse: urlInUse,
      searchType: searchType,
      searchValue: searchValue ?? '%',
    );

    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> insertUpdate({
    required String crossIdentity,
    required String urlInUse,
    required int? concurrentCode,
    required String concurrentName,
    required String observation,
    required AddressEntity? address,
  }) async {
    await datasource.insertUpdate(
      crossIdentity: crossIdentity,
      urlInUse: urlInUse,
      concurrent: ConcurrentModel.fromEntity(
        ConcurrentEntity(
          ConcurrentCode: concurrentCode ?? 0,
          Name: concurrentName,
          Observation: observation,
          Address: address,
        ),
      ),
    );
  }
}
