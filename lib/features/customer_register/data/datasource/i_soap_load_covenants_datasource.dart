import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';

abstract class ISoapLoadCovenantsDatasource {
  Future<List<CovenantModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue, //% to find everything
  });
}
