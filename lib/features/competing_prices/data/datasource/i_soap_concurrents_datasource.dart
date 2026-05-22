import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/data/models/models.dart';

abstract class ISoapConcurrentsDatasource {
  Future<List<ConcurrentModel>> load({
    required String crossIdentity,
    required String workingUrl,
    required SearchConcurrentType searchType,
    required String searchValue,
  });

  Future<void> insertUpdate({
    required String crossIdentity,
    required String workingUrl,
    required ConcurrentModel concurrent,
  });
}
