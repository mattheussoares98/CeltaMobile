import 'package:celta_inventario/core/domain/errors/errors.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/repository/repository.dart';

class SoapInsertUpdateResearchRepositoryImpl
    implements ISoapInsertUpdateResearchRepository {
  final ISoapInsertUpdateResearchDatasource datasource;
  SoapInsertUpdateResearchRepositoryImpl(this.datasource);

  @override
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    ConcurrentEntity? concurrentToAssociate,
    int? researchCode,
    String? observations,
  }) async {
    final associateConcurrentParams = <String, dynamic>{};
    if (concurrentToAssociate != null) {
      if (researchCode == null) {
        throw AppException.localized(CoreFailure.priceSurveyCodeRequired);
      }

      associateConcurrentParams["IsAssociatingConcurrents"] = true;
      associateConcurrentParams["Concurrents"] = [
        {
          "ResearchOfPriceCode": researchCode,
          "ConcurrentCode": concurrentToAssociate.ConcurrentCode,
          "Observation": concurrentToAssociate.Observation,
        },
      ];
    }

    await datasource.insertUpdate(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      name: name,
      observations: observations,
      associateConcurrentParams: associateConcurrentParams,
      researchCode: researchCode ?? 0, //0 is adding new research
    );
  }
}
