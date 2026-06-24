import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcProcessAuthorizationDatasource {
  Future<dynamic> getJudgments(EcRequestParams params);
  Future<dynamic> getStatistics(EcRequestParams params);
}
