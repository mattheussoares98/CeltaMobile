import '../datasource/datasource.dart';
import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/repository/repository.dart';

class SoapConcurrentsRepositoryImpl implements ISoapConcurrentsRepository {
  final ISoapConcurrentsDatasource datasource;
  SoapConcurrentsRepositoryImpl(this.datasource);

  @override
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String workingUrl,
    String? searchValue,
  }) async {
    final searchType = int.tryParse(searchValue ?? '') != null
        ? SearchConcurrentType.exactCode
        : SearchConcurrentType.approximateName;

    final response = await datasource.load(
      crossIdentity: crossIdentity,
      workingUrl: workingUrl,
      searchType: searchType,
      searchValue: searchValue ?? '%',
    );

    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> insertUpdate({
    required String crossIdentity,
    required String workingUrl,
    required int? concurrentCode,
    required String concurrentName,
    required String observation,
    required AddressEntity? address,
  }) async {
    await datasource.insertUpdate(
      crossIdentity: crossIdentity,
      workingUrl: workingUrl,
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
