import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcProcessAuthorizationDatasource {
  Future<List<dynamic>> getJudgments(EcRequestParams params);
  Future<List<dynamic>> getStatistics(EcRequestParams params);
}
