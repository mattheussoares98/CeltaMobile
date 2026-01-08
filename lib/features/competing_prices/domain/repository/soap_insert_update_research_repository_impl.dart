import 'package:celta_intelligence/localization/string_hardcoded.dart';

import '../../../../exceptions/exceptions.dart';
import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

class SoapInsertUpdateResearchRepositoryImpl
    implements ISoapInsertUpdateResearchRepository {
  final ISoapInsertUpdateResearchDatasource datasource;
  SoapInsertUpdateResearchRepositoryImpl(this.datasource);

  @override
  Future<void> insertUpdate({
    required String urlInUse,
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
        throw AppException(
          'Para alterar o concorrente é necessário informar o código da pesquisa'
              .hardcoded,
        );
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
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      name: name,
      observations: observations,
      associateConcurrentParams: associateConcurrentParams,
      researchCode: researchCode ?? 0, //0 is adding new research
    );
  }
}
