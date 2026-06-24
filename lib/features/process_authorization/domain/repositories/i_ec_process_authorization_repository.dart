import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcProcessAuthorizationRepository {
  Future<dynamic> getJudgments(EcRequestParams params);
  Future<dynamic> getStatistics(EcRequestParams params);
}
