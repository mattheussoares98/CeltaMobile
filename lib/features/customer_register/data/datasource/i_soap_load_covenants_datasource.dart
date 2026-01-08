import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapLoadCovenantsDatasource {
  Future<List<CovenantModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue, //% to find everything
  });
}
