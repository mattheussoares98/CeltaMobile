import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapLoadCovenantsDatasource {
  Future<List<CovenantModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue, //% to find everything
  });
}
