import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

abstract class ISoapConcurrentsRepository {
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String workingUrl,
    String? searchValue,
  });

  Future<void> insertUpdate({
    required String crossIdentity,
    required String workingUrl,
    required int? concurrentCode,
    required String concurrentName,
    required String observation,
    required AddressEntity? address,
  });
}
